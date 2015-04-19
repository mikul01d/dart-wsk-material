/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlremote;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _RendererCssClasses {

    final String DYN_CONTENT    = 'mdl-content__adding_content';

    final String LAODING        = 'mdl-content__loading';

    final String LAODED         = 'mdl-content__loaded';

    const _RendererCssClasses();
}

typedef void RenderFunction();

/// Renderer converts a String into HtmlNodes
class Renderer {
    final Logger _logger = new Logger('mdlremote.Renderer');

    static const _RendererCssClasses _cssClasses = const _RendererCssClasses();

    final List<RenderFunction> _renderFunctions = new List<RenderFunction>();

    /// Render the {content} String - {content} must have ONE! top level element
    Future render(final html.Element element, final String content) {
        //_logger.info("Content: $content");

        final Completer completer = new Completer();

        // add the render-function to the list where requestAnimationFrame can pick it
        _renderFunctions.insert(0, () {

            element.classes.remove(_cssClasses.LAODED);
            element.classes.add(_cssClasses.LAODING);

            final html.Element child = new html.Element.html(content,validator: _validator());
            element.childNodes.first.remove();

            child.classes.add(_cssClasses.DYN_CONTENT);
            element.append(child);

            /// check if child is in DOM
            //            new Timer.periodic(new Duration(milliseconds: 10),(final Timer timer) {

            _logger.info("Check for dyn-content...");
            final html.Element dynContent = element.querySelector(".${_cssClasses.DYN_CONTENT}");

            if( dynContent != null) {
                //                    timer.cancel();

                dynContent.classes.remove(_cssClasses.DYN_CONTENT);

                element.classes.remove(_cssClasses.LAODING);
                element.classes.add(_cssClasses.LAODED);

                componenthandler.upgradeElement(element).then((_) => completer.complete());
            }
            //            });
        });

        //new Future(() {
        html.window.requestAnimationFrame( (_) {
            final RenderFunction renderfunction = _renderFunctions.last;
            _renderFunctions.remove(renderfunction);
            renderfunction();
        });


        return completer.future;
    }

    //- private -----------------------------------------------------------------------------------

    html.NodeValidator _validator() {
        final html.NodeValidator validator = new html.NodeValidatorBuilder.common()  // html5 + Templating
            ..allowNavigation()
            ..allowImages()
            ..allowTextElements()
            ..allowInlineStyles()
            ..allowSvg()
            ..add(new _AllowAllAttributesNodeValidator());

        return validator;
    }
}

class _AllowAllAttributesNodeValidator implements html.NodeValidator {

    bool allowsAttribute(html.Element element, String attributeName, String value) {
        if (attributeName == 'is' || attributeName.startsWith('on')) {
            return false;
        }
        return true;
    }

    @override
    bool allowsElement(html.Element element) {
        return true;
    }
}