import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MaterialApp(
    title: "Galado's Natal",
    home: TelaLoginGta(),
    debugShowCheckedModeBanner: false,
  ));
}

Map<String, dynamic>? usuarioLocal;
const Color corOuro = Color(0xFFFFD700);

// --- TELA DE TROLAGEM (BAIXA O TINDER) ---
class TelaDivertida extends StatelessWidget {
  final String sexo;
  const TelaDivertida({super.key, required this.sexo});

  @override
  Widget build(BuildContext context) {
    String termo = sexo == "Masculino" ? "GALADO" : "GALADA";
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/galado.jpg',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text(
                "ENTÃO BAIXA O TINDER, SEU $termo!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, // CORRIGIDO: de black para w900
                  fontStyle: FontStyle.italic
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: corOuro),
                onPressed: () => Navigator.pop(context),
                child: const Text("VOLTAR", style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- TELA DE LOGIN ---
class TelaLoginGta extends StatefulWidget {
  const TelaLoginGta({super.key});
  @override
  _TelaLoginGtaState createState() => _TelaLoginGtaState();
}

class _TelaLoginGtaState extends State<TelaLoginGta> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _ctrlLogin = TextEditingController();
  final _ctrlSenha = TextEditingController();
  bool _mostrarMenu = false;

  @override
  void initState() {
    super.initState();
    _iniciarTimerMenu();
    _iniciarMusicaAmbiente();
  }

  void _iniciarTimerMenu() {
    Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _mostrarMenu = true);
    });
  }

  void _iniciarMusicaAmbiente() async {
    try {
      await _audioPlayer.setVolume(0.01);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sons/ondas.mp3'));
    } catch (e) {
      debugPrint("Erro áudio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset('assets/images/imagem1.jpg', fit: BoxFit.cover)),
          if (_mostrarMenu) ...[
            Container(color: Colors.black.withOpacity(0.4)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text("GALADO'S", style: TextStyle(color: corOuro, fontSize: 55, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                      const Text("NATAL CITY", style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 6)),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withOpacity(0.2))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _campo("E-MAIL OU TELEFONE", _ctrlLogin, false),
                            const SizedBox(height: 15),
                            _campo("SENHA", _ctrlSenha, true),
                            const SizedBox(height: 25),
                            _botao("ENTRAR", () {}, true),
                            const SizedBox(height: 15),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaCadastro())),
                                child: const Text("CADASTRE-SE", style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _campo(String l, TextEditingController c, bool o) => TextField(controller: c, obscureText: o, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: l, labelStyle: const TextStyle(color: Colors.white70), enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: corOuro)), filled: true, fillColor: Colors.black45));
  Widget _botao(String t, VoidCallback a, bool d) => SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: d ? corOuro : Colors.white10, padding: const EdgeInsets.all(15)), onPressed: a, child: Text(t, style: TextStyle(color: d ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 18))));
  
  @override
  void dispose() { _audioPlayer.dispose(); super.dispose(); }
}

// --- TELA DE CADASTRO ---
class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _contato = TextEditingController();
  final _nascimento = TextEditingController();
  final _senha = TextEditingController();
  final _confirmarSenha = TextEditingController();

  String _sexo = "Masculino";
  bool _eHetero = true;
  bool _tem8Chars = false, _temNumero = false, _temMaiuscula = false, _senhasIguais = false, _erroConfirmacao = false;

  @override
  void initState() {
    super.initState();
    _senha.addListener(_validar);
    _confirmarSenha.addListener(_validar);
  }

  void _validar() {
    String s = _senha.text;
    String c = _confirmarSenha.text;
    setState(() {
      _tem8Chars = s.length >= 8;
      _temNumero = s.contains(RegExp(r'[0-9]'));
      _temMaiuscula = s.contains(RegExp(r'[A-Z]'));
      _senhasIguais = s.isNotEmpty && s == c;
      _erroConfirmacao = (c.isNotEmpty && s != c);
    });
  }

  void _tentarCadastrar() {
    if (!(_tem8Chars && _temNumero && _temMaiuscula && _senhasIguais)) return;

    if (!_eHetero) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => TelaDivertida(sexo: _sexo))
      );
      return;
    }

    usuarioLocal = {
      'nome': _nome.text,
      'email': _email.text,
      'contato': _contato.text,
      'nascimento': _nascimento.text,
      'senha': _senha.text,
      'sexo': _sexo,
      'heterossexual': _eHetero,
    };
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("CADASTRO", style: TextStyle(color: corOuro)), iconTheme: const IconThemeData(color: corOuro)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _in("NOME COMPLETO", _nome),
            _in("E-MAIL", _email, tipo: TextInputType.emailAddress),
            _in("TELEFONE (DDD + NÚMERO)", _contato, tipo: TextInputType.phone, formatters: [_TelefoneFormatter()]),
            _in("DATA NASCIMENTO", _nascimento, tipo: TextInputType.number, formatters: [_DataFormatter()]),
            
            const SizedBox(height: 15),
            const Text("SEXO:", style: TextStyle(color: Colors.white60, fontSize: 12)),
            Row(
              children: [
                Radio(value: "Masculino", groupValue: _sexo, onChanged: (v) => setState(() => _sexo = v!), activeColor: corOuro),
                const Text("Masculino", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 20),
                Radio(value: "Feminino", groupValue: _sexo, onChanged: (v) => setState(() => _sexo = v!), activeColor: corOuro),
                const Text("Feminino", style: TextStyle(color: Colors.white)),
              ],
            ),

            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white24),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Identifico-me como heterossexual", style: TextStyle(color: Colors.white, fontSize: 14)),
                value: _eHetero,
                onChanged: (v) => setState(() => _eHetero = v!),
                activeColor: corOuro,
                checkColor: Colors.black,
                // CORRIGIDO: de controlType para controlAffinity
                controlAffinity: ListTileControlAffinity.leading, 
              ),
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white10),
            _in("CRIE UMA SENHA", _senha, obs: true),
            _in("CONFIRME A SENHA", _confirmarSenha, obs: true, erro: _erroConfirmacao),
            
            if (_erroConfirmacao) const Padding(padding: EdgeInsets.only(bottom: 10), child: Text("As senhas não coincidem!", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold))),
            
            const Text("SEGURANÇA:", style: TextStyle(color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 10),
            _check("8+ caracteres", _tem8Chars),
            _check("Número e Maiúscula", _temNumero && _temMaiuscula),
            _check("Senhas iguais", _senhasIguais),
            
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: corOuro, padding: const EdgeInsets.all(18)), onPressed: _tentarCadastrar, child: const Text("FINALIZAR CADASTRO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
  
  Widget _check(String t, bool ok) => Row(children: [Icon(ok ? Icons.check_circle : Icons.circle_outlined, color: ok ? Colors.green : Colors.white24, size: 14), const SizedBox(width: 8), Text(t, style: TextStyle(color: ok ? Colors.green : Colors.white54, fontSize: 12))]);
  Widget _in(String l, TextEditingController c, {bool obs = false, bool erro = false, TextInputType? tipo, List<TextInputFormatter>? formatters}) => Padding(padding: const EdgeInsets.only(bottom: 15), child: TextField(obscureText: obs, controller: c, keyboardType: tipo, inputFormatters: formatters, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: l, labelStyle: const TextStyle(color: Colors.white60, fontSize: 12), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: erro ? Colors.redAccent : Colors.white24)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: erro ? Colors.redAccent : corOuro)))));
  
  @override
  void dispose() { _senha.dispose(); _confirmarSenha.dispose(); super.dispose(); }
}

// FORMATADORES
class _TelefoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) return newValue;
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('55') && digits.length > 2) digits = digits.substring(2);
    if (digits.length > 11) digits = digits.substring(0, 11);
    final buffer = StringBuffer();
    if (digits.isNotEmpty) {
      buffer.write('+55 ');
      if (digits.length >= 1) {
        buffer.write('(');
        buffer.write(digits.substring(0, digits.length >= 2 ? 2 : digits.length));
        if (digits.length >= 2) buffer.write(') ');
      }
      if (digits.length > 2) buffer.write(digits.substring(2, digits.length >= 7 ? 7 : digits.length));
      if (digits.length > 7) buffer.write('-${digits.substring(7, digits.length >= 11 ? 11 : digits.length)}');
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}

class _DataFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) return newValue;
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) buffer.write('/');
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}