class BorderInfo {
  boolean isInline;
  int parentBorderOrder = -1;

  BorderInfo(boolean _isInline) {
    isInline = _isInline;
    //parentOrder = _order;
  }
  
  void setParent(int _order) {
    parentBorderOrder = _order;
  }
}