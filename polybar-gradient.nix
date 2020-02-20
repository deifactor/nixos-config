with import <nixpkgs/lib>;
with builtins;

# This function generates blocks of modules that have a 'gradient' effect,
# including Powerline-style separators.
#
# The first argument is a unique-ifying name prefix.  The second argument is a
# list of color codes.  The second argument indicates which modules to use.
# Each value is either a function that generates a module's attributes (but
# *not* the name), or `null` to indicate that there should be a separator
# there.
#
# The return value has two attributes: `names` is a space-separated name of the
# modules, and `modules` is an attribute set of the actual modules.
#
# This is what happens when a former Haskell programmer with too much time on
# her hands gets into Nix.
{ name, colors, separator }:
attrCallbacks:
let
  go = { colorIndex, modules, index }:
    callback: {
      # null means increment the color index
      colorIndex = if callback == null then colorIndex + 1 else colorIndex;
      index = index + 1;
      modules = modules ++ [{
        name = "module/g-${name}-${toString index}";
        value = if callback != null then
          callback (elemAt colors colorIndex)
        else {
          type = "custom/text";
          content = separator;
          content-foreground = elemAt colors (colorIndex + 1);
          content-background = elemAt colors colorIndex;
        };
      }];
    };
  result = foldl go {
    colorIndex = 0;
    index = 0;
    modules = [ ];
  } attrCallbacks;

in assert (assertMsg (length colors > count isNull attrCallbacks)
  "you need more colors than separators"); {
    modules = listToAttrs result.modules;
    names = concatMapStringsSep " " (x: baseNameOf x.name) result.modules;
  }
