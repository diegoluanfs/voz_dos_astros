import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voz dos Astros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Horóscopo do Dia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> signos = [
    'Áries',
    'Touro',
    'Gêmeos',
    'Câncer',
    'Leão',
    'Virgem',
    'Libra',
    'Escorpião',
    'Sagitário',
    'Capricórnio',
    'Aquário',
    'Peixes',
  ];
  String? signoSelecionado;
  String? resultado;

  final Map<String, String> backgrounds = {
    'Áries': 'assets/bg_aries.png',
    'Touro': 'assets/bg_touro.png',
    'Gêmeos': 'assets/bg_gemeos.png',
    'Câncer': 'assets/bg_cancer.png',
    'Leão': 'assets/bg_leao.png',
    'Virgem': 'assets/bg_virgem.png',
    'Libra': 'assets/bg_libra.png',
    'Escorpião': 'assets/bg_escorpiao.png',
    'Sagitário': 'assets/bg_sagitario.png',
    'Capricórnio': 'assets/bg_capricornio.png',
    'Aquário': 'assets/bg_aquario.png',
    'Peixes': 'assets/bg_peixes.png',
  };

  Future<void> buscarHoroscopo() async {
    if (signoSelecionado == null) {
      setState(() {
        resultado = 'Por favor, selecione um signo!';
      });
      return;
    }

    final agora = DateTime.now();
    final mes = agora.month;
    final ano = agora.year;
    final dia = agora.day;

    // Monta o nome do arquivo conforme o mês
    String nomeArquivo;
    if (mes == 5) {
      nomeArquivo = 'assets/horoscopos_maio_$ano.json';
    } else if (mes == 6) {
      nomeArquivo = 'assets/horoscopos_junho_$ano.json';
    } else if (mes == 7) {
      nomeArquivo = 'assets/horoscopos_julho_$ano.json';
    } else if (mes == 8) {
      nomeArquivo = 'assets/horoscopos_agosto_$ano.json';
    } else {
      setState(() {
        resultado = 'Arquivo de horóscopo não encontrado para este mês ($mes).';
      });
      return;
    }

    try {
      setState(() {
        resultado = 'Tentando carregar: $nomeArquivo';
      });

      String jsonString = await rootBundle.loadString(nomeArquivo);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      String dataChave =
          '$ano-${mes.toString().padLeft(2, '0')}-${dia.toString().padLeft(2, '0')}';

      if (jsonData.containsKey(dataChave) &&
          jsonData[dataChave].containsKey(signoSelecionado)) {
        final info = jsonData[dataChave][signoSelecionado];
        setState(() {
          resultado =
              '${info["text"] ?? "Sem texto"}\n\n ${info["inspiration"] ?? "Sem inspiração"}';
        });
      } else {
        setState(() {
          resultado = 'Não há horóscopo disponível para hoje para este signo.';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'Erro ao carregar o arquivo: $nomeArquivo\n\nErro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? bgPath =
        backgrounds[signoSelecionado ?? ''] ?? 'assets/bg_default.png';

    // Se não houver bg para o signo, usa o default
    if (signoSelecionado == null ||
        !backgrounds.containsKey(signoSelecionado)) {
      bgPath = 'assets/bg_default.png';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bgPath), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                // Mostra o resultado acima do seletor
                if (resultado != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(
                          0.5,
                        ), // Fundo cinza escuro transparente
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        resultado!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ), // Espaço extra entre resposta e seletor
                // const Text('Selecione seu signo:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple, width: 1),
                  ),
                  child: DropdownButton<String>(
                    value: signoSelecionado,
                    hint: const Text('Escolha um signo'),
                    items:
                        signos.map((String signo) {
                          return DropdownMenuItem<String>(
                            value: signo,
                            child: Text(signo),
                          );
                        }).toList(),
                    onChanged: (String? novoValor) {
                      setState(() {
                        signoSelecionado = novoValor;
                        resultado =
                            null; // Limpa o texto da tela ao trocar de signo
                      });
                    },
                    underline: const SizedBox(),
                    dropdownColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: buscarHoroscopo,
                  child: const Text('Buscar'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
