# 🚀 WSO2 APIM & MCP Smart Sandbox

A fully automated, containerized solution to spin up a complete WSO2 API Manager 4.6.0 environment from a simple OpenAPI Specification (OAS). 

This project is designed to drastically reduce the time needed to create demonstrations, test environments, and AI-ready API integrations. Just drop your Swagger/OAS file, run a single Docker command, and get a fully published API with mocking, a deployed Model Context Protocol (MCP) server, and ready-to-use OAuth2 tokens.

## ✨ Features (The "Smart Sandbox" Magic)

By simply running Docker Compose, this automation pipeline performs the following steps without any human intervention:

1. **APIM Initialization:** Spins up a fresh instance of WSO2 API Manager 4.6.0.
2. **OAS to API:** Automatically parses your OpenAPI file and creates a Publisher API.
3. **Auto-Mocking:** Configures an `INLINE` backend mock based on the examples provided in your OAS file (No real backend required!).
4. **MCP Server Generation:** Dynamically runs a Python script to translate your OAS into an LLM-compatible MCP (Model Context Protocol) Server.
5. **Gateway Deployment:** Deploys both the API and the MCP Server to the Default Gateway and publishes them.
6. **Consumer Automation:** Creates a `DefaultApplication` in the Developer Portal.
7. **Auto-Subscription:** Subscribes the application to both the API and the MCP Server with an "Unlimited" business plan.
8. **Token Generation:** Automatically generates Production and Sandbox OAuth2 access tokens and prints them directly to your console.

## 📁 Directory Structure

Ensure your project follows this structure before running:

```text
.
├── docker-compose.yml
├── Dockerfile
└── src/
    └── openapi/
        └── your_openapi_spec.yaml  <-- Drop your OAS 3.0/Swagger file here!
```
*(Note: You can place `.yaml` or `.json` files inside the `src/openapi/` folder).*

## 🚀 Getting Started

### Prerequisites
* Docker
* Docker Compose
* Create a .env file in the root directory with the following structure:

```text
# WSO2 APIM Configuration
APIM_URL=[https://github.com/wso2/product-apim/releases/download/v4.7.0-rc2/wso2am-4.7.0-rc2.zip](https://github.com/wso2/product-apim/releases/download/v4.7.0-rc2/wso2am-4.7.0-rc2.zip)
APIM_FOLDER=wso2am-4.7.0

# WSO2 Identity Server Configuration
IS_URL=[https://github.com/wso2/product-is/releases/download/v7.3.0-rc1/wso2is-7.3.0-rc1.zip](https://github.com/wso2/product-is/releases/download/v7.3.0-rc1/wso2is-7.3.0-rc1.zip)
IS_FOLDER=wso2is-7.3.0

# API Controller (apictl) Downloads
APICTL_URL_ARM64=[https://github.com/wso2/product-apim-tooling/releases/download/v4.7.0-rc2/apictl-4.7.0-rc2-linux-arm64.tar.gz](https://github.com/wso2/product-apim-tooling/releases/download/v4.7.0-rc2/apictl-4.7.0-rc2-linux-arm64.tar.gz)
APICTL_URL_X64=[https://github.com/wso2/product-apim-tooling/releases/download/v4.7.0-rc2/apictl-4.7.0-rc2-linux-x64.tar.gz](https://github.com/wso2/product-apim-tooling/releases/download/v4.7.0-rc2/apictl-4.7.0-rc2-linux-x64.tar.gz)

# Port OFFSSET configuration for WSO2 Identity Server
IS_PORT_OFFSET=3
```

### Execution

1. Place your OpenAPI specification file inside the `./src/openapi/` directory.
2. Open your terminal in the root directory of this project.
3. Run the following command:

```bash
To start ONLY the API Manager:
./run.sh -apim

To start ONLY the Identity Server:
./run.sh -is

To start BOTH (APIM + IS):
./run.sh -is-apim

To clean the images you need to add -clean in any of above
```

### 🎯 What to Expect

The build process will download WSO2, setup `apictl`, and start the server. Once the server is up, the automation script will trigger. Keep an eye on your terminal; once the process finishes, you will be greeted with a success banner containing your tokens:

```text
APIM
==================================================================
 🎉 TODO LISTO: API + MOCK + PORTAL + MCP SERVER DEPLOYED 🎉
 
 Usa estos tokens en Postman o en tu LLM:
 🔴 Token PRODUCCION : eyJhbGciOiJSUzI1...
 🔵 Token SANDBOX    : eyJhbGciOiJSUzI1...
==================================================================

IS
==================================================================
 🎉 TODO IS SERVER DEPLOYED 🎉
  ==================================================================
```

## 🌐 Accessing the Portals

APIM
You can access the WSO2 Web Interfaces using the default credentials (`admin` / `admin`):

* **Publisher Portal:** [https://localhost:9443/publisher](https://localhost:9443/publisher)
* **Developer Portal:** [https://localhost:9443/devportal](https://localhost:9443/devportal)
* **Carbon Management Console:** [https://localhost:9443/carbon](https://localhost:9443/carbon)

IS
* **Console:**[https://localhost:9446/console](https://localhost:9446/console)

## 🛠️ Testing Your Setup

* **Standard API:** Open Postman, paste your `PRODUCCION` token as a Bearer Token, and hit your Gateway endpoints (`https://localhost:8243/your-api-context/1.0.0/...`). You will receive the mocked responses defined in your OAS.
* **LLM Integration:** Connect an LLM (like Claude Desktop or Cursor) to the generated MCP Server endpoint using the generated API Keys to let the AI interact with your mock APIs natively.

## ⚙️ Under the Hood

This project leverages:
* `wso2am` based on the config .env distribution.
* `wsois` based on the config .env distribution.
* `apictl` (WSO2 CLI tool) for artifact initialization and status management.
* WSO2 Publisher & DevPortal Native REST APIs for deployment, application creation, and token generation.
* Embedded `Python 3` for precise YAML manipulation and MCP translation.
* `jq` for JSON payload parsing during the CI/CD bash script execution.

---
*Created for fast-paced API Development and WSO2 IS, QA Sandboxing, and AI/LLM Integration Demos. By Pablo Sagarna*