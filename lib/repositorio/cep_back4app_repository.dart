import 'package:dio_back4app_desafio_cep/model/cep.dart';
import 'package:dio_back4app_desafio_cep/repositorio/cep_backapp_baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CepBack4AppRepository {
  var _cep = CepBack4ppBaseUrl();

  CepBack4AppRepository() {
    _cep = CepBack4ppBaseUrl();
  }

  Future<ViaCepModel> obterListaCep() async {
    var url = "/ViaCep";

    var response = await _cep.dio.get(url);
    var tarefasModel = ViaCepModel.fromJson(response.data);

    return tarefasModel;
  }

  Future<ViaCepModel> consultarCEP(String cep) async {
    String stringWithHyphen = "${cep.substring(0, 5)}-${cep.substring(5)}";

    var isCepRegisted =
        await _cep.dio.get("/ViaCep?where={\"cep\":\"$stringWithHyphen\"}");

    if (isCepRegisted.data["results"].length > 0) {
      var cepModel = ViaCepModel.fromJson(isCepRegisted.data["results"][0]);
      return cepModel;
    }

    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      await salvar(ViaCepModel.fromJson(json));
      return ViaCepModel.fromJson(json);
    }
    return ViaCepModel();
  }

  Future<void> salvar(ViaCepModel cepModel) async {
    try {
      await _cep.dio.post("/ViaCep", data: cepModel.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  // Listar todos os CEPs
  Future<List<ViaCepModel>> listarAll() async {
    try {
      var response = await _cep.dio.get("/ViaCep");
      var lista = response.data["results"] as List;
      var listaCep = lista.map((item) => ViaCepModel.fromJson(item)).toList();
      return listaCep;
    } catch (e) {
      throw Exception(e);
    }
  }
}
