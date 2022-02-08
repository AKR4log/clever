// ignore_for_file: non_constant_identifier_names

class Application {
  final String title;
  final String description;
  final bool animated;
  final String createdDate;
  final String state;
  final bool public;
  final String uidFile;
  final String author;
  final Map url;
  final categories;

  Application(
      {this.animated,
      this.title,
      this.description,
      this.uidFile,
      this.createdDate,
      this.state,
      this.author,
      this.url,
      this.categories,
      this.public});
}
