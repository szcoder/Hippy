/*
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2022 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  HippyAny,
  HippyMap,
  HippyRenderCallback,
  HippyValue
} from '../../../support/common/HippyTypes';
import { HRComponent } from '../../HippyRenderView';
import { NativeRenderContext } from '../../NativeRenderContext';
import HippyRenderBaseView, { HippyObservedArray,
  HIPPY_COMPONENT_KEY_PREFIX } from '../base/HippyRenderBaseView';
import { LogUtils } from '../../../support/utils/LogUtils';
import { HREventUtils } from '../../utils/HREventUtils';
import { HRValueUtils } from '../../utils/HRValueUtils';

type LocalFontWeight = number | FontWeight

@Observed
export class HRTextInputView extends HippyRenderBaseView {
  public caretColor: ResourceColor = Color.Transparent
  public color: ResourceColor = Color.Black
  public fontFamily:string = 'HarmonyOS Sans'
  public fontSize:number = 14
  public fontStyle:FontStyle = FontStyle.Normal
  public fontWeight:LocalFontWeight = FontWeight.Normal
  public maxLength:number = 0xFFFFFFFF
  public multiline:boolean = false
  public textAlign:TextAlign = TextAlign.Start
  public textAlignVertical:Alignment = Alignment.Center
  public value: string = ''
  public keyboardType: InputType = InputType.Normal
  public returnKeyType: EnterKeyType = EnterKeyType.Done
  public placeholder: string = ''
  public placeholderTextColor: ResourceColor = Color.Gray
  public uiCtx:UIContext | null = null

  controller:TextInputController = new TextInputController()
  textAreaController:TextAreaController = new TextAreaController()

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    LogUtils.d("HRTextInput", `propKey:${propKey}, propValue:${propValue}`)
    if (propKey === 'caret-color') {
      this.caretColor = HRValueUtils.getNumber(propValue as HippyAny)
    } else if (propKey === 'color') {
      this.color = HRValueUtils.getNumber(propValue as HippyAny)
    } else if (propKey === 'defaultValue') {
      this.value = HRValueUtils.getString(propValue as HippyAny)
    } else if (propKey === 'fontFamily') {
      this.fontFamily = HRValueUtils.getString(propValue as HippyAny)
    } else if (propKey === 'fontSize') {
      this.fontSize = HRValueUtils.getNumber(propValue as HippyAny)
    } else if (propKey === 'fontStyle') {
      let fontStyle = HRValueUtils.getString(propValue as HippyAny)
      if (fontStyle === 'italic') {
        this.fontStyle = FontStyle.Italic
      }
    } else if (propKey === 'fontWeight') {
      this.setFontWeight(propValue)
    } else if (propKey === 'maxLength') {
      this.maxLength = HRValueUtils.getNumber(propValue as HippyAny)
    } else if (propKey === 'multiline') {
      this.multiline = HRValueUtils.getBoolean(propValue as HippyAny,true)
    } else if (propKey === 'textAlign') {
      this.setTextAlign(propValue)
    } else if (propKey === 'textAlignVertical') {
      this.setTextAlignVertical(propValue)
    } else if (propKey === 'placeholder') {
      this.placeholder = HRValueUtils.getString(propValue as HippyAny)
    } else if (propKey === 'placeholderTextColor') {
      this.placeholderTextColor = HRValueUtils.getNumber(propValue as HippyAny)
    } else if (propKey === 'keyboardType') {
      this.setKeyBoardType(propValue)
    } else if (propKey === 'returnKeyType') {
      this.setEntryKeyType(propValue)
    }

    return super.setProp(propKey, propValue)
  }

  setFontWeight(propValue: HippyAny) {
    let value = HRValueUtils.getString(propValue as HippyAny)

    if (value === '' || value === 'normal') {
      this.fontWeight = FontWeight.Normal
    } else if (value === 'bold') {
      this.fontWeight = FontWeight.Bold
    } else {
      let weight = Number(value) || 0
      if (weight != 0) {
        this.fontWeight = weight
      } else {
        this.fontWeight = FontWeight.Normal
      }
    }
  }

  setTextAlign(propValue: HippyAny) {
    let value = HRValueUtils.getString(propValue as HippyAny)

    //no Gravity.NO_GRAVITY like android
    this.textAlign = TextAlign.Start
    if (value === 'center') {
      this.textAlign = TextAlign.Center
    } else if (value === 'right') {
      this.textAlign = TextAlign.End
    }
  }

  setTextAlignVertical(propValue: HippyAny) {
    let value = HRValueUtils.getString(propValue as HippyAny)

    //no Gravity.NO_GRAVITY like android
    this.textAlignVertical = Alignment.Center
    if (value === 'top') {
      this.textAlignVertical = Alignment.Top
    } else if (value === 'bottom') {
      this.textAlignVertical = Alignment.Bottom
    }
  }

  setKeyBoardType(propValue: HippyAny) {
    this.keyboardType = InputType.Normal

    let type = HRValueUtils.getString(propValue as HippyAny)
    LogUtils.d('HRTextInput', "keyboardType:" + propValue)
    if (type === "numeric") {
      this.keyboardType = InputType.Number
    } else if (type === "password") {
      this.keyboardType = InputType.Password
    } else if (type === "email") {
      this.keyboardType = InputType.Email
    } else if (type === "phone-pad") {
      this.keyboardType = InputType.PhoneNumber
    }
  }

  setEntryKeyType(propValue:HippyAny) {
    this.returnKeyType = EnterKeyType.Done

    let type = HRValueUtils.getString(propValue as HippyAny)
    LogUtils.d('HRTextInput', "returnKeyType:" + type)
    if (type === "go") {
      this.returnKeyType = EnterKeyType.Go
    } else if (type === "next") {
      this.returnKeyType = EnterKeyType.Next
    } else if (type === "search") {
      this.returnKeyType = EnterKeyType.Search
    } else if (type === "send") {
      this.returnKeyType = EnterKeyType.Send
    }
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
    LogUtils.d('HRTextInput', `call:${method}, paras:${params}`)
    let result:HippyAny = null
    if (method === "getValue" && callback) {
      result = new Map<string, HippyValue>() as HippyMap;
      result.set("text", this.value);
      callback(result)
    } else if (method === "focusTextInput") {
      this.focusTextInput(params)
    } else if (method === "blurTextInput") {
      this.blurTextInput(params)
    } else if (method === "clear") {
      this.setText(null)
    } else if (method === "hideInputMethod") {
      this.hideInputMethod(params)
    } else if (method === "setValue") {
      this.setText(params)
    }
  }

  setText(params: Array<HippyAny> | null) {
    let txt = ''
    if (params) {
      if (typeof params[0] != 'string') {
        return
      }

      txt = HRValueUtils.getString(params[0])
      //todo: only change the text, not set the selection pos
    }

    this.value = txt
  }

  focusTextInput(params: Array<HippyAny>) {
    this.uiCtx?.runScopedTask(()=>{
      let rtn = focusControl.requestFocus(HIPPY_COMPONENT_KEY_PREFIX + this.tag)
      LogUtils.d('HRTextInput', `focusTextInput key:${HIPPY_COMPONENT_KEY_PREFIX + this.tag}, rtn:${rtn}`)
    })
  }

  blurTextInput(params: Array<HippyAny>) {
    //todo
  }

  hideInputMethod(params: Array<HippyAny>) {
    this.controller.stopEditing()
  }

}

@Component
export struct HRTextInput {
  private readonly TAG = "HRTextInput";
  @ObjectLink renderView: HRTextInputView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>
  @BuilderParam buildRenderView: ($$: HippyRenderBaseView, parent: HRComponent) => void

  onChange(value: string) {
    LogUtils.d(this.TAG, `onchange:${value}`)
    this.renderView.value = value

    let params = new Map<string, HippyValue>() as HippyMap;
    params.set("text", value);
    HREventUtils.sendComponentEvent(this.renderView.ctx, this.renderView.tag, "changetext", params);
  }

  onTextChange(start:number, end:number) {
    let selection = new Map<string, HippyValue>() as HippyMap;
    selection.set("start", start);
    selection.set("end", end);

    let params = new Map<string, HippyAny>();
    params.set("selection", selection);
    HREventUtils.sendComponentEvent(this.renderView.ctx, this.renderView.tag, "selectionchange", params as HippyMap);
    LogUtils.d(this.TAG, `onTextSelectionChange start:${start}, end:${end}, paras:${params}`)
  }

  aboutToAppear(): void {
    this.renderView.uiCtx = this.getUIContext()
  }

  build() {
   if (this.renderView.multiline) {
      TextArea({
        text:this.renderView.value,
        placeholder: this.renderView.placeholder,
        controller: this.renderView.textAreaController
      })
        .applyTextAreaRenderViewBaseAttr(this.renderView)
        //.type(this.renderView.keyboardType)
        .placeholderColor(this.renderView.placeholderTextColor)
        //.enterKeyType(this.renderView.returnKeyType)
        .fontColor(this.renderView.color)
        .caretColor(this.renderView.caretColor)
        .fontFamily(this.renderView.fontFamily)
        .fontSize(this.renderView.fontSize)
        .fontStyle(this.renderView.fontStyle)
        .fontWeight(this.renderView.fontWeight)
        .maxLength(this.renderView.maxLength)
        .textAlign(this.renderView.textAlign)
        .align(this.renderView.textAlignVertical)
        .onChange((value: string) => {
          this.onChange(value)
        })
        .onTextSelectionChange((start: number, end: number) => {
          this.onTextChange(start, end)
        })
    }
    else {
      TextInput({
        text:this.renderView.value,
        placeholder: this.renderView.placeholder,
        controller: this.renderView.controller
      })//.expandSafeArea([SafeAreaType.KEYBOARD],[ SafeAreaEdge.BOTTOM]) //TODO
        .applyRenderViewBaseAttr(this.renderView)
        .type(this.renderView.keyboardType)
        .placeholderColor(this.renderView.placeholderTextColor)
        .enterKeyType(this.renderView.returnKeyType)
        .fontColor(this.renderView.color)
        .caretColor(this.renderView.caretColor)
        .fontFamily(this.renderView.fontFamily)
        .fontSize(this.renderView.fontSize)
        .fontStyle(this.renderView.fontStyle)
        .fontWeight(this.renderView.fontWeight)
        .maxLength(this.renderView.maxLength)
        .textAlign(this.renderView.textAlign)
        .align(this.renderView.textAlignVertical)
        .onChange((value: string) => {
          this.onChange(value)
        })
        .onSubmit((entryKey: EnterKeyType, event: SubmitEvent) => {
          LogUtils.d(this.TAG, `submit new url:${event.text}, keyType:${entryKey}`)

          let params = new Map<string, HippyValue>() as HippyMap;
          params.set("text", event.text);
          HREventUtils.sendComponentEvent(this.renderView.ctx, this.renderView.tag, "endediting", params);

          // params.set("actionCode", entryKey as number)
          // params.set("actionName", "done")
          // HREventUtils.sendComponentEvent(this.renderView.ctx, this.renderView.tag, "onEditorAction", params);
        })
        .onTextSelectionChange((start: number, end: number) => {
          this.onTextChange(start, end)
        })
   }
  }
}

// base props for all components
@Extend(TextInput)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .accessibilityText($$.cssAccessibilityLabel)
  .focusable($$.cssFocusable)
  .border($$.cssBorder)
  .shadow($$.cssShadow)
  .linearGradient($$.cssLinearGradient)
  .backgroundImage($$.cssBackgroundImage)
  .backgroundImageSize($$.cssBackgroundImageSize)
  .backgroundImagePosition($$.cssBackgroundImagePosition)
  .transform($$.cssMatrix)
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .hitTestBehavior($$.hitTestBehavior)
  .onClick($$.eventClick)
}

// base props for all components
@Extend(TextArea)
function applyTextAreaRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .accessibilityText($$.cssAccessibilityLabel)
  .focusable($$.cssFocusable)
  .border($$.cssBorder)
  .shadow($$.cssShadow)
  .linearGradient($$.cssLinearGradient)
  .backgroundImage($$.cssBackgroundImage)
  .backgroundImageSize($$.cssBackgroundImageSize)
  .backgroundImagePosition($$.cssBackgroundImagePosition)
  .transform($$.cssMatrix)
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .hitTestBehavior($$.hitTestBehavior)
  .onClick($$.eventClick)
}