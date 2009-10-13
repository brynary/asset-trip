require "spec_helper"

describe BlobBundler::Compressor do
  it "minifies JavaScript using the YUI Compressor" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main"
      end
    CONFIG

    write_javascript("main.js", <<-JAVASCRIPT)
      // Comment
      function foo() {
        var long_var_name = 1;
        return long_var_name + 1;
      }
    JAVASCRIPT
    bundle!

    blob("signup.js").should_not have_contents('Comment')
    blob("signup.js").should have_contents('return a+1')
  end

  it "minifies CSS using the YUI Compressor" do
    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      /* Comment */
      .foo {
        font-weight: bold;
      }
    STYLESHEET
    bundle!

    blob("signup.css").should_not have_contents('Comment')
    blob("signup.css").should have_contents('.foo{font-weight:bold;}')
  end
end
