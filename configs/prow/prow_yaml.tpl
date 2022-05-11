presubmits:
  - name: "bazel-test-all"
    branches:
    - main
    decorate: true
    always_run: true
    skip_report: false
    spec:
      containers:
      - image: {ci_runner_image}
        command:
        - "bazel"
        - "test"
        - "--config=remote"
        - "//..."

postsubmits:
  - name: "bazel-test-all"
    branches:
    - main
    decorate: true
    always_run: true
    skip_report: false
    spec:
      containers:
      - image: {ci_runner_image}
        command:
        - "bazel"
        - "test"
        - "--config=remote"
        - "//..."
