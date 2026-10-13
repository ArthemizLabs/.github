// Alterna PT-BR / EN. PT é o padrão; a escolha fica salva no navegador.
(function () {
  var root = document.documentElement;
  var KEY = "arthemiz-lang";

  function apply(lang) {
    var en = lang === "en";
    root.lang = en ? "en" : "pt-BR";
    var opts = document.querySelectorAll(".lang-opt");
    for (var i = 0; i < opts.length; i++) {
      opts[i].classList.toggle("is-active", opts[i].getAttribute("data-opt") === (en ? "en" : "pt"));
    }
  }

  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  apply(saved === "en" ? "en" : "pt");

  var btn = document.getElementById("lang-toggle");
  if (btn) {
    btn.addEventListener("click", function () {
      var next = root.lang === "en" ? "pt" : "en";
      apply(next);
      try { localStorage.setItem(KEY, next); } catch (e) {}
    });
  }
})();
