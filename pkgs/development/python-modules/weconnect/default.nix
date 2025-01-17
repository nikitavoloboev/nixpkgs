{
  lib,
  ascii-magic,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  pillow,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "weconnect";
  version = "0.60.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tillsteinbach";
    repo = "WeConnect-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-sSO+e6pZj7pkkfWF2z5THaD6MrPBX7f1M3nRIoqRC2s=";
  };

  postPatch = ''
    substituteInPlace weconnect/__version.py \
      --replace-fail "0.0.0dev" "${version}"
    substituteInPlace setup.py \
      --replace-fail "setup_requires=SETUP_REQUIRED" "setup_requires=[]" \
      --replace-fail "tests_require=TEST_REQUIRED" "tests_require=[]"
    substituteInPlace pytest.ini \
      --replace-fail "--cov=weconnect --cov-config=.coveragerc --cov-report html" "" \
      --replace-fail "required_plugins = pytest-cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    oauthlib
    requests
  ];

  optional-dependencies = {
    Images = [
      ascii-magic
      pillow
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "weconnect" ];

  meta = with lib; {
    description = "Python client for the Volkswagen WeConnect Services";
    homepage = "https://github.com/tillsteinbach/WeConnect-python";
    changelog = "https://github.com/tillsteinbach/WeConnect-python/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
