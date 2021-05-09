void barGraph(float[] data, float _x, float _y, float _w, float _h, int ci) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(52, 73, 94), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(0)
  };
  pushStyle();
  noStroke();
  float delta = ceil(_w / data.length);
  for (int p = 0; p < data.length; p++) {
    float i = data[p];
    int cIndex = (int) i%10;//min(, colors.length-1);
    if (i<0) fill(255);
    else fill(color(82, 179, 217));
    float h = map(0, -1, 0, 0, _h);
    rect(_x, _y-h, delta, h);
    _x = _x + delta;
  }
  popStyle();
}

float[] appendArray (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length];
  arrayCopy(array, tempArray, tempArray.length);
  array[array.length-1] = _val;
  arrayCopy(tempArray, 1, array, 0, tempArray.length-1);
  return array;
}
