

class SemsterModel {
  String id = " ";
  String semster = " ";
  String year = " ";
  bool isActive = false;
  SemsterModel.m();
  SemsterModel.n(this.id, this.semster, this.year, this.isActive);
  toDictionary() {
    return {"id": id, "semster": semster, "year": year, "isActive": isActive};
  }

  String getSemster() {
    return semster;
  }

  SemsterModel.z(Map value) {
    id = value['id'] as String;
    semster = value['semster'] as String;
    year = value['year'] as String;
    isActive = value['isActive'] as bool;
  }
}
