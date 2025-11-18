# AI Coding Agent Prompt --- Flutter Desktop App

## ROLE

You are an expert Flutter developer specializing in desktop applications
for Windows. Build a full Flutter project following the requirements
below. Follow the file structure strictly.

------------------------------------------------------------------------

## PROJECT GOAL

Create a **Flutter desktop app** that lets the user:

1.  Select a prompt\
2.  Select a PAD (Power Automate Desktop) flow\
3.  Provide input\
4.  Call OpenAI API\
5.  Process response\
6.  Trigger a PAD flow\
7.  Wait for its result\
8.  Display final message

The app must also include a **Settings / Management** screen where the
user can create, edit, and delete prompts and PAD flows.

------------------------------------------------------------------------

## PROJECT STRUCTURE

    lib/
     ├─ main.dart
     ├─ screens/
     │    ├─ home_screen.dart
     │    ├─ settings_screen.dart
     │    ├─ execution_screen.dart
     │
     ├─ services/
     │    ├─ api_service.dart
     │    ├─ pad_service.dart
     │    ├─ config_service.dart
     │
     ├─ models/
     │    ├─ prompt_model.dart
     │    ├─ pad_flow_model.dart
     │    ├─ config_model.dart
     │
     ├─ widgets/
     │    ├─ flow_selector.dart
     │    ├─ input_box.dart
     │    ├─ response_viewer.dart
     │
     └─ data/
          ├─ prompts.json
          ├─ pad_flows.json
          ├─ app_config.json

------------------------------------------------------------------------

## FEATURE REQUIREMENTS

### 1. Home Screen

-   Dropdown: select prompt\
-   Dropdown: select PAD flow\
-   Input text box\
-   **Run** button\
-   When pressed:
    -   Send prompt + input to OpenAI\
    -   Prepare data\
    -   Call PAD service\
    -   Poll until PAD returns\
    -   Display final output

------------------------------------------------------------------------

### 2. Settings Screen

Management interface for:

#### Prompts

-   Add new prompt\
-   Edit prompt\
-   Delete prompt

#### PAD Flows

-   Add flow\
-   Edit flow\
-   Delete flow

All changes must be written to JSON files in `/data`.

------------------------------------------------------------------------

### 3. Services

#### `api_service.dart`

-   Sends request to OpenAI API
-   Uses placeholder API key
-   Returns prepared data for PAD

#### `pad_service.dart`

-   Run a Windows executable, batch file, or simulate PAD
-   Return stdout
-   Implement optional polling

#### `config_service.dart`

-   Load/save JSON files
-   Provide methods for prompts and PAD flows

------------------------------------------------------------------------

### 4. Models

Models must include fromJson / toJson.

-   `Prompt`
-   `PadFlow`
-   `AppConfig`

------------------------------------------------------------------------

### 5. Widgets

Reusable UI components:

-   `flow_selector.dart`\
-   `input_box.dart`\
-   `response_viewer.dart`

------------------------------------------------------------------------

### 6. Execution Screen

Displays: - Spinner (progress indicator)\
- Logs from OpenAI\
- Logs from PAD\
- Final result

------------------------------------------------------------------------

## TECHNICAL REQUIREMENTS

-   Use **Provider** for state management\
-   Must run on **Windows Flutter Desktop**\
-   Use **Material 3**\
-   Provide comments\
-   Include sample JSON data\
-   Must be able to compile\
-   Use mocks where real PAD integration isn't possible

------------------------------------------------------------------------

## OUTPUT EXPECTATION

The agent must generate:

1.  Entire Flutter project with the given structure\
2.  Fully implemented screens, services, models, and widgets\
3.  JSON files with sample content\
4.  Complete run instructions\
5.  A mock PAD execution wrapper

------------------------------------------------------------------------

## FINAL INSTRUCTION

**BEGIN NOW AND GENERATE THE FULL PROJECT.**
