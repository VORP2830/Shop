import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    //Quando o widget for criado é importante adicionar um listener
    //para o campo de imagem para que toda vez que o campo for alterado
    //o widget seja reconstruído
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void dispose() {
    //Quando o widget for removido da árvore de widgets
    //é importante realizar o dispose do FocusNode
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(() {});
    super.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        //O Form é utilizado para controlar os campos de texto
        //e realizar a validação dos dados inseridos
        child: Form(
          child: Column(
            children: [
              //O TextFormField é utilizado para capturar os dados
              //inseridos pelo usuário
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  //Quando o usuário pressionar o botão de avançar do teclado
                  //o foco será transferido para o campo _priceFocusNode
                  //que no caso é o de preco
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                focusNode: _priceFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  //Quando o usuário pressionar o botão de avançar do teclado
                  //o foco será transferido para o campo _priceFocusNode
                  //que no caso é o de preco
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                maxLines: 3,
                onFieldSubmitted: (_) {
                  //Quando o usuário pressionar o botão de avançar do teclado
                  //o foco será transferido para o campo _priceFocusNode
                  //que no caso é o de preco
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'URL da Imagem'),
                      focusNode: _imageUrlFocusNode,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Imagem URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
