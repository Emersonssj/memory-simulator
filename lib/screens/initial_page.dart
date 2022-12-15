import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projetoso/screens/memory_page.dart';
import 'package:validatorless/validatorless.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final qtdProcessosController = TextEditingController(text: "20");
  final tamanhoMemoriaController = TextEditingController(text: "100");
  final memoriaSOController = TextEditingController(text: "20");
  final estrategiaAlocacaoController = TextEditingController(text: "Worst fit");

  final minMemoriaProcessoController = TextEditingController(text: "10");
  final maxMemoriaProcessoController = TextEditingController(text: "30");

  final minMomentoCriacaoController = TextEditingController(text: "5");
  final maxMomentoCriacaoController = TextEditingController(text: "10");

  final minDuracaoController = TextEditingController(text: "10");
  final maxDuracaoController = TextEditingController(text: "30");

  final _formKey = GlobalKey<FormState>();

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeto SO'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: Validatorless.required('Campo obrigatório'),
                    keyboardType: TextInputType.number,
                    controller: qtdProcessosController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantidade de processos',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: estrategiaAlocacaoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Estrategia de alocação',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: Validatorless.required('Campo obrigatório'),
                    keyboardType: TextInputType.number,
                    controller: tamanhoMemoriaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tamanho da memória real',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: Validatorless.required('Campo obrigatório'),
                    keyboardType: TextInputType.number,
                    controller: memoriaSOController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Memoria ocupada pelo SO',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Intervalo para gerar aleatoriamente a área ocupada por cada processo na memória (MB)',
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: minMemoriaProcessoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Min',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: maxMemoriaProcessoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Max',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Intervalo para gerar aleatoriamente o tempo de criação de cada processo em relação ao processo criado anteriormente (segundos)',
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: minMomentoCriacaoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Min',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: maxMomentoCriacaoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Max',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Intervalo para gerar aleatoriamente a duração de cada processo (segundos)',
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: minDuracaoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Min',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator:
                              Validatorless.required('Campo obrigatório'),
                          keyboardType: TextInputType.number,
                          controller: maxDuracaoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Max',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    isExtended: true,
                    onPressed: sendData,
                    label: Text('Iniciar'),
                    backgroundColor: Color.fromARGB(255, 255, 41, 26),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void sendData() async {
    var formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: MemoryPage(
            quantidadeDeProcessos: int.parse(qtdProcessosController.text),
            tamanhoMemoria: int.parse(tamanhoMemoriaController.text),
            memoriaSO: int.parse(memoriaSOController.text),
            estrategiaAlocacao: estrategiaAlocacaoController.text,
            minMemoriaProcesso: int.parse(minMemoriaProcessoController.text),
            maxMemoriaProcesso: int.parse(maxMemoriaProcessoController.text),
            minMomentoCriacao: int.parse(minMomentoCriacaoController.text),
            maxMomentoCriacao: int.parse(maxMomentoCriacaoController.text),
            minDuracaoProcesso: int.parse(minDuracaoController.text),
            maxDuracaoProcesso: int.parse(maxDuracaoController.text),
          ),
          type: PageTransitionType.size,
          alignment: Alignment.centerRight,
        ),
      );
    }
  }
}


/*
  quantidade de processos
  Estratégia de alocação utilizada: first fit, best fit ou worst fit
  Tamanho da memória real (MB)
  Tamanho da área de memória ocupada pelo sistema operacional (MB)
  [M1, M2] - Intervalo para gerar aleatoriamente a área ocupada por cada processo na memória (MB);

  [tc1, tc2] - Intervalo para gerar aleatoriamente o tempo de criação de cada processo em
  relação ao processo criado anteriormente (segundos). Portanto, o instante de criação
  do processo é a soma do valor gerado aleatoriamente neste intervalo com o instante
  em que foi criado o processo anterior;

  [td1, td2] - Intervalo para gerar aleatoriamente a duração de cada processo (segundos).
  A duração representa quanto tempo o processo fica utilizando a memória a partir do
  instante em que ele foi alocado.
*/

/*
Saídas:
A cada instante, o programa deverá mostrar na tela as seguintes informações:
• Mapa da memória, mostrando a área de memória ocupada por cada processo e as
áreas livres;
• Os processos que estão alocados na memória;
• Os processos que estão na fila aguardando a liberação de espaço de memória para
serem alocados;
• Os instantes de tempo em que cada processo foi criado, foi alocado na memória e
concluiu sua execução;
• Tempo de espera de cada processo (diferença entre o instante de conclusão e o
instante de criação);

falta isso
• Tempo médio de espera dos processos que já concluíram (média do tempo de espera
de cada processo);
• Percentual de memória utilizada.
falta isso


fila
PROCESSO 1> Criado em 15s > tamanho 10kb 

execução
bloco PROCESSO 1, TAMANHO 10kb, 

concluido
PROCESSO 1> Criado em 15s > alocado na memoria em 16s > concluido em 20s > tempo de espera 50s

tempo medio = 15s
percentual de memoria utilizada
*/