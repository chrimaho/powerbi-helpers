let
    fun_TransformFile =
        (BinaryContent as binary) =>
            let
                Text = Text.FromBinary(BinaryContent)
            in
                Text
in
    fun_TransformFile