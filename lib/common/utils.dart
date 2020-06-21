double ensureDouble(num input) {
  if (input is int) return input.toDouble();
  return input;
}
