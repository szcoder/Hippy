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

#pragma once

#include <memory>
#include "renderer/native_render.h"

namespace hippy {
inline namespace render {
inline namespace native {

class NativeRenderContext {
public:
  NativeRenderContext(uint32_t instance_id, uint32_t root_id, std::shared_ptr<NativeRender> &native_render)
    : instance_id_(instance_id), root_id_(root_id), native_render_(native_render) {}
  
  uint32_t GetInstanceId() { return instance_id_;}
  uint32_t GetRootId() { return root_id_; }
  std::weak_ptr<NativeRender> GetNativeRender() { return native_render_; }
  
private:
  uint32_t instance_id_;
  uint32_t root_id_;
  std::weak_ptr<NativeRender> native_render_;
};

} // namespace native
} // namespace render
} // namespace hippy
