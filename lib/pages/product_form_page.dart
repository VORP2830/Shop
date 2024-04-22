import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    //Quando o widget for criado é importante adicionar um listener
    //para o campo de imagem para que toda vez que o campo for alterado
    //o widget seja reconstruído
    _imageUrlFocusNode.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      final product = arg as Product;
      _formData['id'] = product.id;
      _formData['name'] = product.name;
      _formData['price'] = product.price;
      _formData['description'] = product.description;
      _formData['imageUrl'] = product.imageUrl;
      _imageUrlController.text = product.imageUrl;
    }
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endWithFile = url.toLowerCase().contains('.png') ||
        url.toLowerCase().contains('.jpg') ||
        url.toLowerCase().contains('.jpeg');
    return isValidUrl && endWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    //Não pode chamar o provider com listen: false pois é necessário
    //que a lista de produtos seja atualizada na tela de produtos
    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
    //Fecha a tela de formulário
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          //O Form é utilizado para controlar os campos de texto
          //e realizar a validação dos dados inseridos
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //O TextFormField é utilizado para capturar os dados
                //inseridos pelo usuário
                TextFormField(
                  //Caso exista um valor no campo name ele será exibido
                  initialValue: _formData['name']?.toString(),
                  decoration: const InputDecoration(labelText: 'Nome'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    //Quando o usuário pressionar o botão de avançar do teclado
                    //o foco será transferido para o campo _priceFocusNode
                    //que no caso é o de preco
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => _formData['name'] = value ?? '',
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().isEmpty) {
                      return 'Nome é obrigatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData['price']?.toString(),
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
                  onSaved: (value) =>
                      _formData['price'] = double.parse(value ?? '0.0'),
                  validator: (_price) {
                    final price = double.tryParse(_price ?? '') ?? 0.0;
                    if (price <= 0) {
                      return 'Informe um preço válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData['description']?.toString(),
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
                  onSaved: (value) => _formData['description'] = value ?? '',
                  validator: (_description) {
                    final description = _description ?? '';
                    if (description.trim().isEmpty) {
                      return 'Descrição é obrigatória';
                    }
                    if (description.trim().length < 10) {
                      return 'Descrição muito curta';
                    }
                    return null;
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
                        onFieldSubmitted: (value) => _submitForm(),
                        onSaved: (value) => _formData['imageUrl'] = value ?? '',
                        validator: (_imageUrl) {
                          final imageUrl = _imageUrl ?? '';
                          if (imageUrl.trim().isEmpty) {
                            return 'Informe a URL da imagem';
                          }
                          if (!isValidImageUrl(imageUrl)) {
                            return 'Informe uma URL válida';
                          }
                          return null;
                        },
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
                  onPressed: _submitForm,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
