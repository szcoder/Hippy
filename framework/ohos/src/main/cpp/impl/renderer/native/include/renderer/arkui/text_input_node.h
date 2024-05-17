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

#include "renderer/arkui/text_input_base_node.h"

namespace hippy {
inline namespace render {
inline namespace native {

class TextInputNodeDelegate {
public:
  virtual ~TextInputNodeDelegate() = default;
  virtual void OnChange(std::string text){}
  virtual void OnBlur(){}
  virtual void OnFocus(){}
  virtual void OnSubmit(){}
  virtual void OnPaste(){}
  virtual void OnTextSelectionChange(int32_t location, int32_t length){}
};

class TextInputNode : public TextInputBaseNode {
protected:
  TextInputNodeDelegate *textInputNodeDelegate_;

public:
  TextInputNode();
  ~TextInputNode();
  
  void OnNodeEvent(ArkUI_NodeEvent *event) override;
  void SetTextInputNodeDelegate(TextInputNodeDelegate *textInputNodeDelegate);
  
  void SetTextContent(std::string const &textContent) override;
  void SetTextSelection(int32_t start, int32_t end) override;
  void SetCaretColor(uint32_t const &color) override;
  void SetMaxLength(int32_t maxLength) override;
  void SetPlaceholder(std::string const &placeholder) override;
  void SetPlaceholderColor(uint32_t const &color) override;
  std::string GetTextContent() override;

  HRPoint GetTextInputOffset() const;
  void SetCaretHidden(bool hidden);
  void SetInputType(ArkUI_TextInputType keyboardType);
  void SetSelectedBackgroundColor(uint32_t const &color);
  void SetPasswordIconVisibility(bool isVisible);
  void SetEnterKeyType(uint32_t returnKeyType);
  void SetCancelButtonMode(uint32_t mode);
  void ResetSelectedBackgroundColor();
};

} // namespace native
} // namespace render
} // namespace hippy
