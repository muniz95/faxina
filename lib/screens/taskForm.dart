import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TaskBloc _bloc;
  Task task = new Task();

  @override
  Widget build(BuildContext context) {
    var submitBtn = new RaisedButton(
      onPressed: () {
        _submit();
        Navigator.of(context).pop();
      },
      child: new Text("Salvar"),
    );

    _bloc = Provider.of(context).taskBloc;
    return new StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Cadastro de tarefas"),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Text(
                  "Nova tarefa",
                  textScaleFactor: 2.0,
                ),
                new Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          onSaved: (val) {
                            task.name = val;
                          },
                          validator: (val) {
                            return val.length < 1
                                ? "Name must have atleast 1 chars"
                                : null;
                          },
                          decoration: new InputDecoration(labelText: "Nome"),
                        ),
                      ),
                    ],
                  ),
                ),
                submitBtn
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )
        );
      },
    );
  }

  void _submit() {
    final form = formKey.currentState;
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (form.validate()) {
      form.save();
      _bloc.addTask(task);
      // var store = StoreProvider.of<AppState>(context);
      // Product product = new Product(
      //   name: _name,
      //   quantity: _quantity,
      //   category: _category,
      //   code: _code,
      //   user: store.state.userState.user,
      // );

      // setState(() => _isLoading = false);
      // var db = new DB();
      // db.saveProduct(product)
      // .then((res) {
      //   store.dispatch(new AddProductToList(product));
      //   _showSnackBar('Produto cadastrado com sucesso!');
      //   new Future.delayed(new Duration(seconds: 3)).then((_) {
      //     Navigator.of(_ctx).pop("/home");
      //   });
      // })
      // .catchError((err) {
      //   _showSnackBar('Error: $err');
      // });
    }
  }

}