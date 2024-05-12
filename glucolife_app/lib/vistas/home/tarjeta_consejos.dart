import 'package:flutter/material.dart';
import 'package:glucolife_app/claves.dart';
import 'package:glucolife_app/provider/provider_usuario.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:provider/provider.dart';

class TarjetaConsejoVista extends StatefulWidget {
  const TarjetaConsejoVista({Key? key}) : super(key: key);

  @override
  State<TarjetaConsejoVista> createState() => _TarjetaConsejoVistaState();
}

class _TarjetaConsejoVistaState extends State<TarjetaConsejoVista> {
  final TextEditingController _textController = TextEditingController();

  bool loading = false;
  List textChat = [];

  final ScrollController _controller = ScrollController();

  final gemini = GoogleGemini(apiKey: Claves.GeminiKey);

  void fromText({required String query}) {
    /// Llamada al provider para poder mantener la vista actualizada
    final usuarioModel = Provider.of<UsuarioProvider>(context, listen: false);
    setState(() {
      loading = true;
      textChat.add({
        "role": usuarioModel.obtenerUsuario?.nombre ?? "Usuario",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({"role": "Samantha", "text": value.text});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({"role": "Samantha", "text": error.toString()});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        height: 300,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consejo del día:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (textChat.isEmpty) ...[
                Expanded(
                  flex: 10,
                  child: Center(
                    child: Text(
                      'Hola👋 soy Samantha:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: textChat.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        child: Text(textChat[index]["role"].substring(0, 1)),
                      ),
                      title: Text(textChat[index]["role"]),
                      subtitle: Text(textChat[index]["text"]),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 26),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textController,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Pregúntale a Samantha tus dudas...',
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(height: 0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: loading
                                ? const CircularProgressIndicator()
                                : InkWell(
                                    onTap: () {
                                      fromText(query: _textController.text);
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
