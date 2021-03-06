context("Trained Inputs")


library(recipes)

df <- ICHomes
fo1 <- sale_amount ~ sale_year + built + style + construction
fo2 <- sale_amount ~ sale_year + base_size + bedrooms + basement

rec1 <- recipe(sale_amount ~ ., data = ICHomes)
rec2 <- rec1 %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_pca(all_numeric(), -all_outcomes(), id = "pca")

sel_fo <- SelectedInput(fo1, fo2, data = df)
sel_mat <- SelectedInput(
  model.matrix(~ sale_year + built + style + construction, ICHomes)[, -1],
  model.matrix(~ sale_year + base_size + bedrooms + basement, ICHomes)[, -1],
  y = ICHomes$sale_amount
)
sel_mf <- SelectedInput(
  ModelFrame(fo1, data = df),
  ModelFrame(fo2, data = df)
)
sel_mo_mf <- SelectedInput(
  ModeledInput(fo1, data = df, model = GLMModel),
  ModeledInput(fo2, data = df, model = GBMModel)
)
sel_rec <- SelectedInput(rec1, rec2)
sel_mo_rec <- SelectedInput(
  ModeledInput(rec1, model = GLMModel),
  ModeledInput(rec2, model = GBMModel)
)
tun_rec <- TunedInput(rec2, grid = expand_steps(pca = list(num_comp = 1:3)))


models <- c(
  "GLMModel" = GLMModel,
  "TunedModel(GLMNet)" = TunedModel(GLMNetModel),
  "SelectedModel(SVMModel, RangerModel)" = SelectedModel(SVMModel, RangerModel)
)


for (name in names(models)) {

  model <- models[[name]]

  test_that("model fitting of selected model frames", {
    skip_if_not(TEST_TRAINING)
    context(paste0(name, ": SelectedModelFrame Fitting"))
    with_parallel({
      expect_is(fit(sel_fo, model = model), "MLModelFit")
      expect_is(fit(sel_mat, model = model), "MLModelFit")
      expect_is(fit(sel_mf, model = model), "MLModelFit")
    })
  })

  test_that("model fitting of selected recipes", {
    skip_if_not(TEST_TRAINING)
    context(paste0(name, ": SelectedModelRecipe Fitting"))
    with_parallel({
      expect_is(fit(sel_rec, model = model), "MLModelFit")
    })
  })

  test_that("model fitting of tuned recipe", {
    skip_if_not(TEST_TRAINING)
    context(paste0(name, ": TunedModelRecipe Fitting"))
    with_parallel({
      expect_is(fit(tun_rec, model = model), "MLModelFit")
    })
  })

}


test_that("model fitting of selected inputs", {
  skip_if_not(TEST_TRAINING)
  context("SelectedModeledInput Fitting")
  with_parallel({
    model <- models[[1]]
    expect_is(fit(sel_mo_mf), "MLModelFit")
    expect_is(fit(sel_mo_rec), "MLModelFit")
  })
})


test_that("resampling of selected inputs", {
  skip_if_not(TEST_TRAINING)
  context("SelectedInput Resampling")
  with_parallel({
    model <- models[[1]]
    expect_is(resample(sel_mf, model = model), "Resamples")
    expect_is(resample(sel_mo_mf), "Resamples")
    expect_is(resample(sel_rec, model = model), "Resamples")
    expect_is(resample(sel_mo_rec), "Resamples")
  })
})


test_that("resampling of tuned inputs", {
  skip_if_not(TEST_TRAINING)
  context("TunedInput Resampling")
  with_parallel({
    model <- models[[1]]
    expect_is(resample(tun_rec, model = model), "Resamples")
  })
})
