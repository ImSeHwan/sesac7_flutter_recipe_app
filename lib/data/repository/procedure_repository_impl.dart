import 'dart:convert';

import 'package:flutter_recipe_app/core/result.dart';
import 'package:flutter_recipe_app/data/data_source/recipe_data_source.dart';
import 'package:flutter_recipe_app/data/dto/extension/recipe_mapper.dart';
import 'package:flutter_recipe_app/domain/model/step_Info.dart';
import 'package:flutter_recipe_app/domain/repository/procedure_repository.dart';

import '../dto/recipe_dto.dart';

class ProcedureRepositoryImpl implements ProcedureRepository {
  final RecipeDataSource _recipeDataSource;

  ProcedureRepositoryImpl({
    required RecipeDataSource recipeDataSource,
  }) : _recipeDataSource = recipeDataSource;

  @override
  Future<Result<List<StepInfo>, String>> getStepInfos(String recipeId) async {
    try {
      final response = await _recipeDataSource.getRecipes();
      if (response.statusCode == 200) {
        final List<dynamic> recipesRawList = jsonDecode(
          response.body,
        )['recipes'];

        final recipesDto = recipesRawList.map((e) => RecipeDto.fromJson(e)).toList();
        final recipes = recipesDto.map((e) => e.toRecipe()).toList();
        final recipe = recipes.firstWhere((recipe) => recipe.id.toString() == recipeId);

        return Success(value: recipe.steps);
      } else {
        return Failure(exception: 'http status code is not 200');
      }
    } catch (e) {
      return Failure(exception: 'Something went wrong');
    }
  }
}