name: Bug report
description: Report bugs with the engine here
labels: [bug]
body:
  - type: textarea
    id: description
    attributes:
      label: "Describe your bug here."
    validations:
      required: true

  - type: textarea
    id: reproduce
    attributes:
      label: "Steps to reproduce this bug."
    validations:
      required: true

  - type: textarea
    id: terminal
    attributes:
      label: "Command Prompt/Terminal Logs"
      render: bash
    validations:
      required: false
    id: buildsummary
    attributes:
      label: "If you edited anything in this build, mention or summarize your changes."
      placeholder: "I edited ClientPrefs.hx and tried to add a new setting"
    validations:
      required: false

  - type: dropdown
    id: btarget
    attributes:
      label: "What is your platform?"
      options:
        - "Android"
        - "iOS"
    validations:
      required: true