class ClassModel {
  String id = " ";
  String className = " ";
  String point1 = " ";

  ClassModel.m();
  ClassModel.n(this.id, this.className, this.point1);
  toDictionary() {
    return {"id": id, "className": className, "point1": point1};
  }

  String getClassName() {
    return className;
  }

  String getPoint1() {
    return point1;
  }

  ClassModel.z(Map value) {
    id = value['id'] as String;
    className = value['className'] as String;
    point1 = value['point1'] as String;
  }
}
