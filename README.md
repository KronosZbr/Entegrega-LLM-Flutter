# 🧠 Conselhos de Estudo com Gemini + Flutter

Aplicativo Flutter que utiliza a API **Gemini 1.5 Flash** do Google para gerar **conselhos de estudo personalizados**, com suporte à entrada de **voz** e **texto**. O projeto é ideal para quem quer explorar integração com LLMs em Flutter, utilizando um prompt adaptável.

---

## 🚀 Funcionalidades

- ✅ Geração de conselhos de estudo com linguagem natural  
- 🎤 Entrada por voz usando `speech_to_text`  
- ⌨️ Entrada por texto editável  
- 🎨 Interface com tema escuro (Material 3)  
- 🌐 Comunicação com LLM via API Gemini (`google_generative_ai`)  

---

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^5.1.0
  google_generative_ai: ^0.4.3
  speech_to_text: ^7.0.0
```

---

## 🛠️ Como usar

1. **Clone o repositório:**

```bash
git clone https://github.com/KronosZbr/Entegrega-LLM-Flutter
```

2. **Crie o arquivo `.env`:**

Na raiz do projeto, crie um arquivo chamado `.env` com o seguinte conteúdo:

```
API_KEY=SUA_CHAVE_AQUI
```

3. **Adicione o `.env` ao `pubspec.yaml`:**

```yaml
flutter:
  assets:
    - .env
```

4. **Instale as dependências:**

```bash
flutter pub get
```

5. **Execute o app:**

```bash
flutter run
```

---

## 🔐 Permissões Android

No arquivo `android/app/src/main/AndroidManifest.xml`, adicione:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

Isso é necessário para que o reconhecimento de voz funcione corretamente.

---

## 📌 Prompt Utilizado

```text
Você é um mentor estudioso e paciente. Dê conselhos práticos para melhorar o foco e a organização nos estudos.
Use uma linguagem leve, com exemplos simples, e adicione emojis para ilustrar. 🎓📚
```

O aplicativo complementa esse prompt com o que o usuário digitar ou falar para gerar respostas personalizadas.
