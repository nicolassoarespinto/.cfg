" Vim syntax file
" Language:     Dynare
" Maintainer:   Your Name
" Last Change:  2025 March 18
" Version:      1.1
" URL:          https://www.dynare.org/

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Dynare is case sensitive
syntax case match

" Dynare keywords
syntax keyword dynareKeyword var varexo varexo_det parameters model end steady initval endval shocks stoch_simul check estimation bayesian_estimation 
syntax keyword dynareKeyword dynare_sensitivity set_dynare_seed rplot dates dsge_var identification calib_smoother extended_path model_comparison forecast conditional_forecast prior_function
syntax keyword dynareKeyword ramsey_model ramsey_policy discretionary_policy planner_objective bvar_density dsample loaddata homotopy_setup histval perfect_foresight_setup simul resid
syntax keyword dynareKeyword model_diagnostics shock_decomposition forecast_eval_init jforecast_eval_init bvar_forecast stochastic_solvers plot_priors prior_posterior_statistics sbvar
syntax keyword dynareKeyword write_latex_dynamic_model write_latex_static_model analyze_calibration calibration_indices initval_file smoother msdsge mcmc_jumping_covariance
syntax keyword dynareKeyword estimated_params estimated_params_init datafile heteroskedastic_shocks heteroskedastic_filter nodiagnostic diffuse_filter varobs steady_state_model
syntax keyword dynareKeyword osr_params filtered_vars options_ stderr nocheck console_mode mode_compute periods scales

" Parameter distribution keywords
syntax keyword dynareDistribution uniform_pdf normal_pdf gamma_pdf inv_gamma_pdf beta_pdf

" Model block specific keywords
syntax keyword dynareModelKeyword contained min max exp log ln cos sin tan acos asin atan cosh sinh tanh sqrt erf normcdf normpdf

" Dynare functions 
syntax keyword dynareFunction steady_state observation_trends observed_moments compute_root_mean_squared_distance irf_calibration

" Dynare operators and functions 
syntax match dynareOperator /[-+*=<>^]/
syntax match dynareOperator /\.\./ 
syntax match dynareOperator /@\+/
syntax match dynareOperator /#\+/
syntax match dynareOperator /!.*[ ;]/he=e-1
syntax match dynareFunction /\<\([a-zA-Z0-9_]\+\)\s*(/he=e-1

" Constants
syntax match dynareConstant /\<[0-9]\+\(\.[0-9]\+\)\?\([eE][+-]\?[0-9]\+\)\?\>/

" Model variables with offset - highlight specially
syntax match dynareVarOffset /\<\w\+\((\s*[-+]\d\+\s*)\)/

" String literals
syntax region dynareString start=/"/ skip=/\\"/ end=/"/
syntax region dynareString start=/'/ skip=/\\'/ end=/'/

" Comments
syntax region dynareComment start=/\/\*/ end=/\*\//
syntax match dynareComment /\/\/.*$/
syntax match dynareComment /%.*$/
syntax match dynareComment /%%.*$/

" Special section headers in comments
syntax match dynareSection /%\+\s*\d\+\.\s*[A-Za-z0-9 ]\+\s*\%(-\+\)\?%\+$/ 

" Block structures
syntax region dynareModelBlock matchgroup=dynareBlockDecl start=/model\s*;/ end=/end\s*;/ contains=dynareComment,dynareString,dynareConstant,dynareOperator,dynareModelKeyword,dynareFunction,dynareVarOffset

syntax region dynareShocksBlock matchgroup=dynareBlockDecl start=/shocks\s*;/ end=/end\s*;/ contains=dynareComment,dynareString,dynareConstant,dynareOperator,dynareKeyword,dynareFunction

syntax region dynareEstimatedParamsBlock matchgroup=dynareBlockDecl start=/estimated_params\(_init\)\?\s*;/ end=/end\s*;/ contains=ALL

syntax region dynareHistvalBlock matchgroup=dynareBlockDecl start=/histval\s*;/ end=/end\s*;/ contains=ALL

syntax region dynareHeteroShocksBlock matchgroup=dynareBlockDecl start=/heteroskedastic_shocks\s*;/ end=/end\s*;/ contains=ALL

syntax region dynareSteadyStateBlock matchgroup=dynareBlockDecl start=/steady_state_model\s*;/ end=/end\s*;/ contains=ALL

" Highlighting associations
highlight link dynareKeyword     Keyword
highlight link dynareOperator    Operator
highlight link dynareFunction    Function
highlight link dynareConstant    Number
highlight link dynareString      String
highlight link dynareComment     Comment
highlight link dynareBlockDecl   PreProc
highlight link dynareSection     Title
highlight link dynareVarOffset   Special
highlight link dynareModelKeyword Type
highlight link dynareDistribution Type

let b:current_syntax = "dynare"
