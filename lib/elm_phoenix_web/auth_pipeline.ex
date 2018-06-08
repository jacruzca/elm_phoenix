defmodule ElmPhoenix.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :elm_phoenix,
    module: ElmPhoenix.Guardian,
    error_handler: ElmPhoenix.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
