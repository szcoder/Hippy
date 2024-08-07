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

#include "renderer/components/pull_footer_view.h"
#include "renderer/components/list_view.h"
#include "renderer/utils/hr_value_utils.h"

namespace hippy {
inline namespace render {
inline namespace native {

PullFooterView::PullFooterView(std::shared_ptr<NativeRenderContext> &ctx) : ListItemView(ctx) {}

PullFooterView::~PullFooterView() {}

bool PullFooterView::SetProp(const std::string &propKey, const HippyValue &propValue) {
  if (propKey == "sticky") {
    auto value = HRValueUtils::GetBool(propValue, false);
    if (value) {
      sticky_ = value;
    }
    return true;
  }
  return ListItemView::SetProp(propKey, propValue);
}

void PullFooterView::OnSetPropsEnd(){
   return ListItemView::OnSetPropsEnd(); 
}

void PullFooterView::Call(const std::string &method, const std::vector<HippyValue> params,
                          std::function<void(const HippyValue &result)> callback) {
  FOOTSTONE_DLOG(INFO)<<__FUNCTION__<<" method = "<<method; 
  if (method == "collapsePullFooter") {
    Show(false);
  } else {
    BaseView::Call(method, params, callback);
  }
}

void PullFooterView::Show(bool show) {
  if (show != isVisible_) {
    isVisible_ = show;
    GetLocalRootArkUINode().SetVisibility(show);
  }
}

void PullFooterView::UpdateRenderViewFrame(const HRRect &frame, const HRPadding &padding){
//  BaseView::UpdateRenderViewFrame(frame, padding);
}

} // namespace native
} // namespace render
} // namespace hippy
