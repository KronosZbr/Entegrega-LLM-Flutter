import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'services/servico_gemini';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conselhos de Estudo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String _response = '';
  bool _isLoading = false;
  bool _isListening = false;

  String _buildPrompt(String complemento) {
    return '''
Você é um mentor estudioso e paciente. Dê conselhos práticos para melhorar o foco e a organização nos estudos.
Use uma linguagem leve, com exemplos simples, e adicione emojis para ilustrar. 🎓📚
${complemento.trim().isNotEmpty ? '\nComplemento do usuário: $complemento' : ''}
''';
  }

  Future<void> _sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    final prompt = _buildPrompt(userInput);
    final result = await _geminiService.gerarResposta(prompt);

    setState(() {
      _response = result;
      _isLoading = false;
    });
  }

  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conselhos de Estudo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite ou fale algo para complementar o conselho',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _toggleListening,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : () => _sendMessage(_controller.text),
              child: Text(_isLoading ? 'Gerando...' : 'Gerar Conselho'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
