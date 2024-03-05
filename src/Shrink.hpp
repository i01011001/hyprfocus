#include "IFocusAnimation.hpp"

class CShrink : public IFocusAnimation {
public:
  void onWindowFocus(CWindow *pWindow, HANDLE pHandle) override;
  void init(HANDLE pHandle, std::string animationName) override;
  void setup(HANDLE pHandle, std::string animationName) override;

  CAnimatedVariable<float> m_sShrinkAnimation;
};
