#include "renderer/api_c/hippy.h"
#include "renderer/native_render_manager.h"

using namespace hippy;

void HippyViewProvider_BindNativeRoot(void *parent_node_handle, uint32_t render_manager_id, uint32_t root_id, uint32_t node_id) {
  auto &map = NativeRenderManager::PersistentMap();
  std::shared_ptr<NativeRenderManager> render_manager;
  bool ret = map.Find(render_manager_id, render_manager);
  if (!ret) {
    FOOTSTONE_DLOG(WARNING) << "BindRoot: render_manager_id invalid";
    return;
  }

  render_manager->BindNativeRootToParent((ArkUI_NodeHandle)parent_node_handle, root_id, node_id);
}

void HippyViewProvider_UnbindNativeRoot(uint32_t render_manager_id, uint32_t root_id, uint32_t node_id) {
  auto &map = NativeRenderManager::PersistentMap();
  std::shared_ptr<NativeRenderManager> render_manager;
  bool ret = map.Find(render_manager_id, render_manager);
  if (!ret) {
    FOOTSTONE_DLOG(WARNING) << "UnbindRoot: render_manager_id invalid";
    return;
  }

  render_manager->UnbindNativeRootFromParent(root_id, node_id);
}

void HippyViewProvider_UpdateRootSize(uint32_t render_manager_id, uint32_t root_id, float width, float height) {
  auto &map = NativeRenderManager::PersistentMap();
  std::shared_ptr<NativeRenderManager> render_manager;
  bool ret = map.Find(render_manager_id, render_manager);
  if (!ret) {
    FOOTSTONE_DLOG(WARNING) << "UpdateRootSize render_manager_id invalid";
    return;
  }

  auto &root_map = RootNode::PersistentMap();
  std::shared_ptr<RootNode> root_node;
  ret = root_map.Find(root_id, root_node);
  if (!ret) {
    FOOTSTONE_DLOG(WARNING) << "UpdateRootSize root_node is nullptr";
    return;
  }
  
  std::shared_ptr<DomManager> dom_manager = root_node->GetDomManager().lock();
  if (dom_manager == nullptr) {
    FOOTSTONE_DLOG(WARNING) << "UpdateRootSize dom_manager is nullptr";
    return;
  }

  std::vector<std::function<void()>> ops;
  ops.emplace_back([dom_manager, root_node, width, height] {
    FOOTSTONE_LOG(INFO) << "update root size width = " << width << ", height = " << height << std::endl;
    dom_manager->SetRootSize(root_node, width, height);
    dom_manager->DoLayout(root_node);
    dom_manager->EndBatch(root_node);
  });
  dom_manager->PostTask(Scene(std::move(ops)));
}
