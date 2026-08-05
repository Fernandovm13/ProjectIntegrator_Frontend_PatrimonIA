class Community {
  final String id;
  final String name;
  final String region;
  final String initials;
  final int memoryCount;

  const Community({
    required this.id,
    required this.name,
    required this.region,
    required this.initials,
    this.memoryCount = 0,
  });
}
