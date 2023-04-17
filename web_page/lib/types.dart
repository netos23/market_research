typedef Json = Map<String, dynamic>;

const baseUrl = String.fromEnvironment(
  'url',
  defaultValue: 'http://127.0.0.1:5000/',
);
const baseAssetsUrl = '$baseUrl/static/Right';
