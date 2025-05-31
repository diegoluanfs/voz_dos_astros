import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int selectedMenu = 0; // 0: Hoje, 1: Ontem, 2: Semana
  final List<Map<String, dynamic>> signos = [
    {"nome": "Áries", "icone": "assets/icons/aries.svg"},
    {"nome": "Touro", "icone": "assets/icons/touro.svg"},
    {"nome": "Gêmeos", "icone": "assets/icons/gemeos.svg"},
    {"nome": "Câncer", "icone": "assets/icons/cancer.svg"},
    {"nome": "Leão", "icone": "assets/icons/leao.svg"},
    {"nome": "Virgem", "icone": "assets/icons/virgem.svg"},
    {"nome": "Libra", "icone": "assets/icons/libra.svg"},
    {"nome": "Escorpião", "icone": "assets/icons/escorpiao.svg"},
    {"nome": "Sagitário", "icone": "assets/icons/sagitario.svg"},
    {"nome": "Capricórnio", "icone": "assets/icons/capricornio.svg"},
    {"nome": "Aquário", "icone": "assets/icons/aquario.svg"},
    {"nome": "Peixes", "icone": "assets/icons/peixes.svg"},
  ];
  String? signoSelecionado;
  String? resultado;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          // <-- Adicione este widget aqui
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            padding: EdgeInsets.zero,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: List.generate(signos.length, (index) {
              final signo = signos[index];
              final int row = index ~/ 3;
              final int col = index % 3;
              final Color bgColor =
                  ((row + col) % 2 == 0)
                      ? const Color(0xFF7C3AAD)
                      : const Color(0xFF6D299C);

              final now = DateTime.now();
              final meses = [
                'Jan',
                'Fev',
                'Mar',
                'Abr',
                'Mai',
                'Jun',
                'Jul',
                'Ago',
                'Set',
                'Out',
                'Nov',
                'Dez',
              ];
              final dataFormatada =
                  '${now.day.toString().padLeft(2, '0')} ${meses[now.month - 1]}-${now.year.toString().substring(2)}';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignoPage(signo: signo)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dataFormatada,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SvgPicture.asset(
                        signo["icone"],
                        width: 88,
                        height: 88,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        signo["nome"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SignoPage extends StatefulWidget {
  final Map<String, dynamic> signo;
  const SignoPage({super.key, required this.signo});

  @override
  State<SignoPage> createState() => _SignoPageState();
}

class _SignoPageState extends State<SignoPage> {
  int selectedMenu = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _trabalhoKey = GlobalKey();
  final GlobalKey _amorKey = GlobalKey();
  final GlobalKey _compatKey = GlobalKey();

  Map<String, dynamic>? dadosSignoHoje;
  List<String> compativeis = [];
  List<String> naoCompativeis = [];

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    carregarHoroscopo();
  }

  Future<void> carregarHoroscopo() async {
    final agora = DateTime.now();
    final ano = agora.year;
    final mes = agora.month;
    final dia = agora.day;

    String nomeArquivo = '';
    if (mes == 5) {
      nomeArquivo = 'assets/horoscopos_maio_$ano.json';
    } else if (mes == 6) {
      nomeArquivo = 'assets/horoscopos_junho_$ano.json';
    } // adicione outros meses se necessário

    try {
      String jsonString = await rootBundle.loadString(nomeArquivo);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      String dataChave =
          '$ano-${mes.toString().padLeft(2, '0')}-${dia.toString().padLeft(2, '0')}';
      String nomeSigno = widget.signo["nome"];

      if (jsonData.containsKey(dataChave) &&
          jsonData[dataChave].containsKey(nomeSigno)) {
        setState(() {
          dadosSignoHoje = jsonData[dataChave][nomeSigno];
          compativeis = List<String>.from(dadosSignoHoje?["compativel"] ?? []);
          naoCompativeis = List<String>.from(
            dadosSignoHoje?["n-compativel"] ?? [],
          );
        });
      }
    } catch (e) {
      // Trate erro se necessário
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Menu fixo com 6 ícones
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    const MyHomePage(title: 'Horóscopo do Dia'),
                          ),
                          (route) => false,
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/icons/zodiac.svg",
                        width: 55,
                        height: 55,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 45,
                        ),
                        Positioned(
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${DateTime.now().day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.nightlight_round,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () => _scrollTo(_trabalhoKey),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () => _scrollTo(_amorKey),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.style,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: () => _scrollTo(_compatKey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Menu fixo com 3 ícones
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MenuButton(
                      text: "Hoje",
                      selected: selectedMenu == 0,
                      onTap: () => setState(() => selectedMenu = 0),
                    ),
                    _MenuButton(
                      text: "Ontem",
                      selected: selectedMenu == 1,
                      onTap: null, // Desabilitado
                    ),
                    _MenuButton(
                      text: "Semana",
                      selected: selectedMenu == 2,
                      onTap: null, // Desabilitado
                    ),
                  ],
                ),
              ),
              // Conteúdo rolável
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ícone e nome do signo + botão compartilhar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              widget.signo["icone"],
                              width: 72,
                              height: 72,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.signo["nome"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final text = Uri.encodeComponent(
                                        "Confira meu horóscopo no Voz dos Astros!",
                                      );
                                      final url = "https://wa.me/?text=$text";
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(
                                          Uri.parse(url),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Não foi possível abrir o WhatsApp.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Compartilhar com amigos",
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 2,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // SESSÃO TRABALHO
                        Row(
                          key: _trabalhoKey,
                          children: [
                            Icon(Icons.work, color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            const Text(
                              "TRABALHO",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dadosSignoHoje?["trabalho"] ?? "Carregando...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // SESSÃO AMOR
                        Row(
                          key: _amorKey,
                          children: [
                            Icon(Icons.favorite, color: Colors.white, size: 28),
                            const SizedBox(width: 12),
                            const Text(
                              "AMOR",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          dadosSignoHoje?["amor"] ?? "Carregando...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // SESSÃO COMPATÍVEL E NÃO COMPATÍVEL
                        Container(
                          key: _compatKey,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB9F6CA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Compatível",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children:
                                    compativeis
                                        .map(
                                          (nome) => Expanded(
                                            child: _SignoCompatWidget(
                                              nome: nome,
                                              icone:
                                                  "assets/icons/${nome.toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ô', 'o').replaceAll('ê', 'e').replaceAll(' ', '').replaceAll('ô', 'o')}.svg",
                                              iconSize: 88,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Não compatível",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children:
                                    naoCompativeis
                                        .map(
                                          (nome) => Expanded(
                                            child: _SignoCompatWidget(
                                              nome: nome,
                                              icone:
                                                  "assets/icons/${nome.toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ô', 'o').replaceAll('ê', 'e').replaceAll(' ', '').replaceAll('ô', 'o')}.svg",
                                              iconSize: 88,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                        .toList(),
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
          ),
        ),
      ),
    );
  }
}

// Widget para o menu superior
class _MenuButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap; // <-- Permitir nulo
  const _MenuButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Pode ser null
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      onTap == null
                          ? Colors
                              .grey // Desabilitado
                          : (selected ? Colors.blue : Colors.deepPurple),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 32,
                decoration: BoxDecoration(
                  color: selected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para signos compatíveis
class _SignoCompatWidget extends StatelessWidget {
  final String nome;
  final String icone;
  final double iconSize;
  final double fontSize;
  const _SignoCompatWidget({
    required this.nome,
    required this.icone,
    this.iconSize = 40,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignoPage(signo: {"nome": nome, "icone": icone}),
          ),
        );
      },
      child: Column(
        children: [
          SvgPicture.asset(
            icone,
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(height: 4),
          Text(
            nome,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
