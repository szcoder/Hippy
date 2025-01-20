#include <stdint.h>

#if defined(__cplusplus)
#define HIPPY_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define HIPPY_EXTERN extern __attribute__((visibility("default")))
#endif

HIPPY_EXTERN void HippyViewProvider_BindNativeRoot(void *parent_node_handle, uint32_t render_manager_id, uint32_t root_id, uint32_t node_id);
HIPPY_EXTERN void HippyViewProvider_UnbindNativeRoot(uint32_t render_manager_id, uint32_t root_id, uint32_t node_id);
HIPPY_EXTERN void HippyViewProvider_UpdateRootSize(uint32_t render_manager_id, uint32_t root_id, float width, float height);
