#reader(lib "defreader.ss" "scribble")
@require["common.ss"]
@require["snip-class.scrbl"]

@define-class-doc[editor-snip% snip% ()]{

An @scheme[editor-snip%] object is a @scheme[snip%] object that
 contains and displays an @scheme[editor<%>] object. This snip class
 is used to insert an editor as a single @techlink{item} within
 another editor.


@defconstructor[([editor (or/c (is-a?/c text%) false/c) #f]
                 [with-border? any/c #t]
                 [left-margin nonnegative-exact-integer? 5]
                 [top-margin nonnegative-exact-integer? 5]
                 [right-margin nonnegative-exact-integer? 5]
                 [bottom-margin nonnegative-exact-integer? 5]
                 [left-inset nonnegative-exact-integer? 1]
                 [top-inset nonnegative-exact-integer? 1]
                 [right-inset nonnegative-exact-integer? 1]
                 [bottom-inset nonnegative-exact-integer? 1]
                 [min-width (or/c (and/c real? (not/c negative?)) (one/of 'none)) 'none]
                 [max-width (or/c (and/c real? (not/c negative?)) (one/of 'none)) 'none]
                 [min-height (or/c (and/c real? (not/c negative?)) (one/of 'none)) 'none]
                 [max-height (or/c (and/c real? (not/c negative?)) (one/of 'none)) 'none])]{

If @scheme[editor] is non-@scheme[#f], then it will be used as the
 editor contained by the snip. See also @method[editor-snip%
 set-editor].

If @scheme[with-border?] is not @scheme[#f], then a border will be drawn
 around the snip. The editor display will be inset in the snip area by
 the amounts specified in the @scheme[-margin] arguments.  The border
 will be drawn with an inset specified by the @scheme[-inset] arguments.

See @method[editor-snip% get-inset] and @method[editor-snip%
get-margin] for information about the inset and margin arguments.

}


@defmethod[#:mode override 
           (adjust-cursor [dc (is-a?/c dc<%>)]
                          [x real?]
                          [y real?]
                          [editorx real?]
                          [editory real?]
                          [event (is-a?/c mouse-event%)])
           (or/c (is-a?/c cursor%) false/c)]{

Gets a cursor from the embedded editor by calling its
@method[editor<%> adjust-cursor] method.

}


@defmethod[(border-visible?)
           boolean?]{

Returns @scheme[#t] if the snip has a border draw around it,
@scheme[#f] otherwise.

See also @method[editor-snip% show-border].

}


@defmethod[(get-align-top-line)
           boolean?]{

Reports whether the snip is in align-top-line mode. See
@method[editor-snip% get-extent] for more information.

See also @method[editor-snip% set-align-top-line].

}


@defmethod[(get-editor)
           (or/c (or/c @scheme[text%] (is-a?/c pasteboard%)) false/c)]{

Returns the editor contained by the snip, or @scheme[#f] is there is
 no editor.

}

@defmethod[#:mode override 
           (get-extent [dc (is-a?/c dc<%>)]
                       [x real?]
                       [y real?]
                       [w (or/c (box/c (and/c real? (not/c negative?))) false/c) #f]
                       [h (or/c (box/c (and/c real? (not/c negative?))) false/c) #f]
                       [descent (or/c (box/c (and/c real? (not/c negative?))) false/c) #f]
                       [space (or/c (box/c (and/c real? (not/c negative?))) false/c) #f]
                       [lspace (or/c (box/c (and/c real? (not/c negative?))) false/c) #f]
                       [rspace (or/c (box/c (and/c real? (not/c negative?))) false/c) #f])
           void?]{

Calls its editor's @method[editor<%> get-extent] method, then adds the
 editor snip's margins.

The top space always corresponds to the space of the editor's top
 line, plus the snip's top margin. Normally, the descent corresponds
 to the descent of the editor's last line plus the snip's bottom
 margin. However, if the snip is in align-top-line mode (see
 @method[editor-snip% set-align-top-line]), the descent corresponds to
 the descent of the top line, plus the height rest of the editor's
 lines, plus the snip's bottom margin.

If the editor is a text editor, then @scheme[1] is normally subtracted
 from the editor's width as returned by @method[editor<%> get-extent],
 because the result looks better for editing.  If the snip is in
 tight-text-fit mode (see @method[editor-snip% set-tight-text-fit])
 then @scheme[2] is subtracted from a text editor's width, eliminating
 the two pixels that the text editor reserves for the blinking
 caret. In addition, tight-text-fit mode subtracts an amount equal to
 the line spacing from the editor's height. By default, tight-text-fit
 mode is disabled.

}


@defmethod[(get-inset [l (box/c nonnegative-exact-integer?)]
                      [t (box/c nonnegative-exact-integer?)]
                      [r (box/c nonnegative-exact-integer?)]
                      [b (box/c nonnegative-exact-integer?)])
           void?]{

Gets the current border insets for the snip. The inset sets how much space
is left between the edge of the snip and the border.

@boxisfill[(scheme l) @elem{left inset}]
@boxisfill[(scheme t) @elem{top inset}]
@boxisfill[(scheme r) @elem{right inset}]
@boxisfill[(scheme b) @elem{bottom inset}]

}


@defmethod[(get-margin [l (box/c nonnegative-exact-integer?)]
                       [t (box/c nonnegative-exact-integer?)]
                       [r (box/c nonnegative-exact-integer?)]
                       [b (box/c nonnegative-exact-integer?)])
           void?]{

Gets the current margins for the snip. The margin sets how much space
is left between the edge of the editor's contents and the edge of the
snip.

@boxisfill[(scheme l) @elem{left margin}]
@boxisfill[(scheme t) @elem{top margin}]
@boxisfill[(scheme r) @elem{right margin}]
@boxisfill[(scheme b) @elem{bottom margin}]

}


@defmethod[(get-max-height)
           (or/c (and/c real? (not/c negative?)) (one/of 'none))]{

Gets the maximum display height of the snip; zero or @scheme['none]
 indicates that there is no maximum.

}


@defmethod[(get-max-width)
           (or/c (and/c real? (not/c negative?)) (one/of 'none))]{

Gets the maximum display width of the snip; zero or @scheme['none]
 indicates that there is no maximum.

}

@defmethod[(get-min-height)
           (or/c (and/c real? (not/c negative?)) (one/of 'none))]{

Gets the minimum display height of the snip; zero or @scheme['none]
 indicates that there is no minimum.

}

@defmethod[(get-min-width)
           (or/c (and/c real? (not/c negative?)) (one/of 'none))]{

Gets the minimum display width of the snip; zero or @scheme['none]
 indicates that there is no minimum.

}

@defmethod[(get-tight-text-fit)
           boolean?]{

Reports whether the snip is in tight-text-fit mode. See
@method[editor-snip% get-extent] for more information.

See also @method[editor-snip% set-tight-text-fit].

}

@defmethod[#:mode override 
           (resize [w (and/c real? (not/c negative?))]
                   [h (and/c real? (not/c negative?))])
           boolean?]{

Sets the snip's minimum and maximum width and height to the specified
 values minus the snip border space. See also @method[editor-snip%
 set-min-width] @method[editor-snip% set-max-width]
 @method[editor-snip% set-max-height] @method[editor-snip%
 set-min-height].

Also sets the minimum and maximum width of the editor owned by the
 snip to the given width (minus the snip border space) via
 @method[editor<%> set-max-width] and @method[editor<%>
 set-min-width].

}

@defmethod[(set-align-top-line [tight? any/c])
           void?]{

Enables or disables align-top-line mode. See @method[editor-snip%
 get-extent] for more information.

See also @method[editor-snip% get-align-top-line].

}

@defmethod[(set-editor [editor (or/c (or/c @scheme[text%] (is-a?/c pasteboard%)) false/c)])
           void?]{

Sets the editor contained by the snip, releasing the old editor in the
 snip (if any). If the new editor already has an administrator, then
 the new editor is {\em not} installed into the snip.

When an @scheme[editor-snip%] object is not inserted in an editor, it
 does not have an administrator. During this time, it does not give
 its contained editor an administrator, either. The administratorless
 contained editor can therefore ``defect'' to some other
 @techlink{display} with an administrator. When a contained editor
 defects and the snip is eventually inserted into a different editor,
 the snip drops the traitor contained editor, setting its contained
 editor to @scheme[#f].

}

@defmethod[(set-inset [l nonnegative-exact-integer?]
                      [t nonnegative-exact-integer?]
                      [r nonnegative-exact-integer?]
                      [b nonnegative-exact-integer?])
           void?]{

Sets the current border insets for the snip. The inset sets how much
 space is left between the edge of the snip and the border.

}


@defmethod[(set-margin [l nonnegative-exact-integer?]
                       [t nonnegative-exact-integer?]
                       [r nonnegative-exact-integer?]
                       [b nonnegative-exact-integer?])
           void?]{

Sets the current margins for the snip. The margin sets how much space
 is left between the edge of the editor's contents and the edge of the
 snip.

}

@defmethod[(set-max-height [h (or/c (and/c real? (not/c negative?)) (one/of 'none))])
           void?]{

@edsnipmax[(scheme height)]

Zero or @scheme['none] disables the limit.

}

@defmethod[(set-max-width [w (or/c (and/c real? (not/c negative?)) (one/of 'none))])
           void?]{

@edsnipmax[(scheme width)] The contained editor's width limits are not
 changed by this method.

Zero or @scheme['none] disables the limit.

}

@defmethod[(set-min-height [h (or/c (and/c real? (not/c negative?)) (one/of 'none))])
           void?]{

@edsnipmin[(scheme height) @elem{top}]

Zero or @scheme['none] disables the limit.

}

@defmethod[(set-min-width [w (or/c (and/c real? (not/c negative?)) (one/of 'none))])
           void?]{

@edsnipmin[(scheme width) @elem{left}] The contained editor's width
 limits are not changed by this method.

Zero or @scheme['none] disables the limit.

}

@defmethod[(set-tight-text-fit [tight? any/c])
           void?]{

Enables or disables tight-text-fit mode. See @method[editor-snip%
 get-extent] for more information.

See also @method[editor-snip% get-tight-text-fit].

}

@defmethod[(show-border [show? any/c])
           void?]{

Shows or hides the snip's border.

}


@defmethod[(style-background-used?)
           boolean?]{

Returns @scheme[#t] if the snip uses its style's background and
 transparency informaiton when drawing, @scheme[#f] otherwise.

See also @method[editor-snip% use-style-background].

}


@defmethod[(use-style-background [use? any/c])
           void?]{

Causes the snip to use or not used (the default) its style's
 background and transparency information for drawing the background
 within the snip's border.

If @scheme[use?] is @scheme[#f], the style background and transparency
information is ignored, otherwise is it used.

}}

