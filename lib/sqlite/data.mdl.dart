class DbFormMdl {
  final int id;
  final String formId;
  final String title;
  final String userId;
  final int createdDate;
  final int updatedDate;
  DbFormMdl({required this.id, required this.formId, required this.title, required this.userId,
  required this.createdDate, required this.updatedDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formId': formId,
      'title': title,
      'userId': userId,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }
}

class DbFormDataMdl {
  final int submitFormId;
  final String fieldName;
  final String data;
  DbFormDataMdl({required this.submitFormId, required this.fieldName, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'submitFormId': submitFormId,
      'fieldName': fieldName,
      'data': data,
    };
  }
}