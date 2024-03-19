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
import { BridgeCallback, HippyBridge } from './HippyBridge';
import { JsDriver } from '../connector/JsDriver';
import { NativeCallback } from '../connector/NativeCallback';
import { HippyEngineContext } from '../HippyEngineContext';
import { V8InitParams } from '../HippyEngine';
import { MonitorGroupType, TimeMonitor } from '../../support/utils/TimeMonitor';
import { HippyBridgeManagerImpl } from './HippyBridgeManagerImpl';

export class HippyBridgeImpl implements HippyBridge {
  private mEngineContext: HippyEngineContext;
  private mBridgeCallback: BridgeCallback;
  private mEnableV8Serialization: boolean;
  private mIsDevModule: boolean;
  private mDebugServerHost: string;
  private mV8InitParams: V8InitParams | null;
  private mJsDriver: JsDriver;

  public constructor(
    engineContext: HippyEngineContext,
    callback: BridgeCallback,
    enableV8Serialization: boolean,
    isDevModule: boolean,
    debugServerHost: string,
    v8InitParams: V8InitParams | null,
    jsDriver: JsDriver) {
    this.mEngineContext = engineContext;
    this.mBridgeCallback = callback;
    this.mEnableV8Serialization = enableV8Serialization;
    this.mIsDevModule = isDevModule;
    this.mDebugServerHost = debugServerHost;
    this.mV8InitParams = v8InitParams;
    this.mJsDriver = jsDriver;

    // TODO Code Cache
    // if (mCodeCacheRootDir == null) {
    //         Context context = mContext.getGlobalConfigs().getContext();
    //         File hippyFile = FileUtils.getHippyFile(context);
    //         if (hippyFile != null) {
    //             mCodeCacheRootDir =
    //                     hippyFile.getAbsolutePath() + File.separator + "codecache"
    //                             + File.separator;
    //         }
    // }
  }

  initJSBridge(globalConfig: string, callback: NativeCallback, groupId: number): void {
    this.initJSEngine(globalConfig, callback, groupId);
  }

  initJSEngine(globalConfig: string, callback: NativeCallback, groupId: number) {
    this.mEngineContext.getMonitor()
      .startPoint(MonitorGroupType.ENGINE_INITIALIZE, TimeMonitor.MONITOR_POINT_INIT_JS_ENGINE);
    // TODO 多线程问题
    this.mJsDriver.initialize(
      this.mEngineContext.getDomManagerId(),
      this.mEngineContext.getVfsId(),
      callback)
  }

  runScriptFromUri(uri: string, canUseCodeCache: boolean, codeCacheTag: string, callback: NativeCallback): boolean {
    //  if (!mInit) {
    //     return false;
    // }
    const context = this.mEngineContext.getGlobalConfigs().getContext();
    if (context === null) {
      return false;
    }
    const assetManager = context.resourceManager;
    const codeCacheDir = "";
    // TODO Code Cache
    // if (!TextUtils.isEmpty(codeCacheTag) && !TextUtils.isEmpty(mCodeCacheRootDir)) {
    //     codeCacheDir = mCodeCacheRootDir + codeCacheTag + File.separator;
    //     File codeCacheFile = new File(codeCacheDir);
    //     if (!codeCacheFile.exists() && !codeCacheFile.mkdirs()) {
    //         canUseCodeCache = false;
    //         codeCacheDir = "";
    //     }
    // } else {
    //     canUseCodeCache = false;
    // }
    return this.mJsDriver.runScriptFromUri(uri, assetManager, canUseCodeCache, codeCacheDir,
      this.mEngineContext.getVfsId(), callback);
  }

  onDestroy(): void {
    throw new Error('Method not implemented.');
  }

  destroy(callback: NativeCallback, isReload: boolean): void {
    throw new Error('Method not implemented.');
  }

  getV8RuntimeId(): number {
    throw new Error('Method not implemented.');
  }

  callFunction(functionId: number, callback: NativeCallback, buffer: Uint8Array) {
    if (functionId == HippyBridgeManagerImpl.FUNCTION_ACTION_LOAD_INSTANCE) {
      // TODO loadInstance 参数序列化
      this.mJsDriver.loadInstance('');
    } else if (functionId == HippyBridgeManagerImpl.FUNCTION_ACTION_DESTROY_INSTANCE) {
      // mJsDriver.unloadInstance(buffer, 0, length);
    } else {
      // mJsDriver.callFunction(functionName, callback, buffer, 0, length);
    }
  }
}