String eventType(String type) {
  if (type == "custom-wedding") {
    return "Wedding";
  }
  if (type == "custom-disco") {
    return "Disco";
  }
  if (type == "custom-promenade") {
    return "Promenade";
  }
  if (type == "custom-fashion-show") {
    return "Fashion Show";
  }
  if (type == "custom-ball") {
    return "Ball";
  }
  if (type == "custom-party") {
    return "Party";
  }
  return "Invalid Category Tag";
}
