class BorderInfo {
  //内側の輪郭に対する外側の輪郭を親と呼ぶことにする
  
  boolean isInline;
  int parentBorderOrder = -1;

  BorderInfo(boolean _isInline) {
    isInline = _isInline;
  }
  
  void setParent(int _order) {
    parentBorderOrder = _order;
  }
}