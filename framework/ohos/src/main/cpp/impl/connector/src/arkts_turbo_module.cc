/*
 *
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "connector/arkts_turbo_module.h"

#include "connector/turbo.utils.h"
#include "driver/napi/js_ctx.h"
#include "driver/napi/js_ctx_value.h"
#include "driver/napi/callback_info.h"
#include "driver/scope.h"
#include "footstone/logging.h"
#include "footstone/string_view.h"
#include "footstone/string_view_utils.h"
#include "oh_napi/oh_napi_task_runner.h"
#include "oh_napi/oh_napi_object.h"

using string_view = footstone::string_view;
using StringViewUtils = footstone::StringViewUtils;
using Ctx = hippy::Ctx;
using CtxValue = hippy::CtxValue;
using CallbackInfo = hippy::CallbackInfo;
using ScopeWrapper = hippy::ScopeWrapper;
using TurboUtils = hippy::TurboUtils;


namespace hippy {
inline namespace framework {
inline namespace turbo {

std::shared_ptr<CtxValue> ArkTsTurboModule::InvokeArkTsMethod(const std::shared_ptr<CtxValue>& prop_name,
                                                            CallbackInfo& info,
                                                            void* data) {
 FOOTSTONE_DLOG(INFO) << "[turbo-perf] enter invokeArkTSMethod";

  auto scope_wrapper = reinterpret_cast<ScopeWrapper*>(std::any_cast<void*>(info.GetSlot()));
  auto scope = scope_wrapper->scope.lock();
  FOOTSTONE_CHECK(scope);
  auto context = scope->GetContext();
  string_view str_view;
  std::string method;
  std::shared_ptr<CtxValue> result = context->CreateUndefined();
  if (context->GetValueString(prop_name, &str_view)) {
    method = StringViewUtils::ToStdString(
        StringViewUtils::ConvertEncoding(str_view, string_view::Encoding::Utf8).utf8_value());
  }
    
  FOOTSTONE_DLOG(INFO) << "invokeArkTSMethod, method = " << method.c_str();
  auto method_set = method_set_;
  OhNapiTaskRunner *taskRunner = OhNapiTaskRunner::Instance(env);
  taskRunner->RunSyncTask([env = env, impl = impl, &info, context, method, &result, &method_set]() {
      ArkTS arkTs(env);
      napi_ref turbo_module_ref = impl->GetRef();
      auto turboModule = arkTs.GetObject(turbo_module_ref);
      if (method_set.size() <= 0) {
         FOOTSTONE_DLOG(ERROR) << "turboModule object has no method, method = " << method.c_str();
         return;
      }
      if (method_set.find(method) == method_set.end()) {
         FOOTSTONE_DLOG(ERROR) << "turboModule method is null, method = " << method.c_str();
         return;  
      }
      std::vector<napi_value> args;
      for (size_t i = 0; i < info.Length(); ++i) {
        auto item = info[i];
        napi_value value = TurboUtils::CtxValue2NapiValue(env, context, item);
        args.push_back(value); 
      }
      napi_value ret = turboModule.Call(method, args);
      result = TurboUtils::NapiValue2CtxValue(env, ret, context);
  });
  return result;
}

void ArkTsTurboModule::InitMethodSet() {
   ArkTS arkTs(env);
   napi_ref turbo_module_ref = impl->GetRef();
   auto turboModule = arkTs.GetObject(turbo_module_ref);
   if (turboModule.isNull()) {
      FOOTSTONE_DLOG(ERROR) << "turboModule object is null";  
      return; 
   }
   std::vector<std::pair<napi_value, napi_value>> value = turboModule.GetKeyValuePairs();
   if (value.size() <= 0) {
      FOOTSTONE_DLOG(ERROR) << "turboModule object is null";  
      return;
   }
   std::vector<std::pair<napi_value, napi_value>> pairs = turboModule.GetObjectPrototypeProperties();
   for (auto it = pairs.begin(); it != pairs.end(); it++) {
      auto &pair = *it;
      auto &pairItem1 = pair.first;
      auto method = arkTs.GetString(pairItem1);
      method_set_.insert(method);
   }
}

ArkTsTurboModule::ArkTsTurboModule(const std::string& name,
                                 std::shared_ptr<Turbo>& impl,
                                 const std::shared_ptr<Ctx>& ctx,
                                 napi_env env)
  : name(name), impl(impl), env(env) {
  InitMethodSet();
  auto getter = std::make_unique<FunctionWrapper>([](CallbackInfo& info, void* data) {
    auto scope_wrapper = reinterpret_cast<ScopeWrapper*>(std::any_cast<void*>(info.GetSlot()));
    auto scope = scope_wrapper->scope.lock();
    FOOTSTONE_CHECK(scope);
    auto ctx = scope->GetContext();
    auto module = reinterpret_cast<ArkTsTurboModule*>(data);
    auto name = info[0];
    if (!name) {
      return;
    }
    auto func_object = module->func_map[name];
    if (func_object) {
      info.GetReturnValue()->Set(func_object);
      return;
    }
    auto turbo_wrapper = std::make_unique<TurboWrapper>(module, name);
    auto func_wrapper = std::make_unique<FunctionWrapper>([](CallbackInfo& info, void* data) {
      auto scope_wrapper = reinterpret_cast<ScopeWrapper*>(std::any_cast<void*>(info.GetSlot()));
      auto scope = scope_wrapper->scope.lock();
      FOOTSTONE_CHECK(scope);
      auto wrapper = reinterpret_cast<TurboWrapper*>(data);
      FOOTSTONE_CHECK(wrapper && wrapper->module && wrapper->name);
      auto result = wrapper->module->InvokeArkTsMethod(wrapper->name, info, data);
      info.GetReturnValue()->Set(result);
    }, turbo_wrapper.get());
    func_object = ctx->CreateFunction(func_wrapper);
    turbo_wrapper->SetFunctionWrapper(std::move(func_wrapper));
    module->turbo_wrapper_map[name] = std::move(turbo_wrapper);
    module->func_map[name] = func_object;
    info.GetReturnValue()->Set(func_object);
  }, this);
  constructor = ctx->DefineProxy(getter);
  constructor_wrapper = std::move(getter);
}

}
}
}
