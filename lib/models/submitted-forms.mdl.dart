
class SubmittedFormModel {
  String id;
  String formId;
  String title;
  String researcher;
  DateTime submittedDate;
  bool uploaded;


  SubmittedFormModel({
    required this.id,
    required this.formId,
    required this.title,
    required this.researcher,
    required this.submittedDate,
    required this.uploaded
  });

}