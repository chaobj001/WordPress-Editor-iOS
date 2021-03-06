#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_keyboard.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_keyboard@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_underline.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_underline@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_unlink.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_unlink@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_options.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_options@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_preview.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_preview@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSbgcolor.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSbgcolor@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSScenterjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSScenterjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSclearstyle.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSclearstyle@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSforcejustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSforcejustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh1.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh1@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh2.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh2@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh3.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh3@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh4.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh4@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh5.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh5@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh6.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh6@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSShorizontalrule.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSShorizontalrule@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSindent.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSindent@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSleftjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSleftjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSoutdent.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSoutdent@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSquicklink.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSquicklink@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSredo.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSredo@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSrightjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSrightjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsubscript.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsubscript@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsuperscript.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsuperscript@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSStextcolor.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSStextcolor@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSundo.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSundo@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/editor.html"
  install_resource "${PODS_ROOT}/../../Assets/jquery.js"
  install_resource "${PODS_ROOT}/../../Assets/jquery.mobile-events.min.js"
  install_resource "${PODS_ROOT}/../../Assets/js-beautifier.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-classapplier.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-core.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-highlighter.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-selectionsaverestore.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-serializer.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-textrange.js"
  install_resource "${PODS_ROOT}/../../Assets/shortcode.js"
  install_resource "${PODS_ROOT}/../../Assets/underscore-min.js"
  install_resource "${PODS_ROOT}/../../Assets/WPHybridCallbacker.js"
  install_resource "${PODS_ROOT}/../../Assets/WPHybridLogger.js"
  install_resource "${PODS_ROOT}/../../Assets/wpload.js"
  install_resource "${PODS_ROOT}/../../Assets/wpsave.js"
  install_resource "${PODS_ROOT}/../../Assets/ZSSRichTextEditor.js"
  install_resource "${PODS_ROOT}/../../Assets/wpposter.svg"
  install_resource "${PODS_ROOT}/../../Assets/editor.css"
  install_resource "${PODS_ROOT}/../../Assets/WPEditorFormatbarView.xib"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-inspector@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon-posts-editor-preview@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_bold@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_html@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_italic@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_keyboard.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_keyboard@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_link@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_media@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_more@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ol@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_quote@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_strikethrough@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_ul@3x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_underline.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_underline@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_unlink.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_format_unlink@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_options.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_options@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_preview.png"
  install_resource "${PODS_ROOT}/../../Assets/icon_preview@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSbgcolor.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSbgcolor@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSScenterjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSScenterjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSclearstyle.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSclearstyle@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSforcejustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSforcejustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh1.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh1@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh2.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh2@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh3.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh3@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh4.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh4@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh5.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh5@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh6.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSh6@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSShorizontalrule.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSShorizontalrule@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSindent.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSindent@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSleftjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSleftjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSoutdent.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSoutdent@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSquicklink.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSquicklink@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSredo.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSredo@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSrightjustify.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSrightjustify@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsubscript.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsubscript@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsuperscript.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSsuperscript@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSStextcolor.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSStextcolor@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSundo.png"
  install_resource "${PODS_ROOT}/../../Assets/ZSSundo@2x.png"
  install_resource "${PODS_ROOT}/../../Assets/editor.html"
  install_resource "${PODS_ROOT}/../../Assets/jquery.js"
  install_resource "${PODS_ROOT}/../../Assets/jquery.mobile-events.min.js"
  install_resource "${PODS_ROOT}/../../Assets/js-beautifier.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-classapplier.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-core.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-highlighter.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-selectionsaverestore.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-serializer.js"
  install_resource "${PODS_ROOT}/../../Assets/rangy-textrange.js"
  install_resource "${PODS_ROOT}/../../Assets/shortcode.js"
  install_resource "${PODS_ROOT}/../../Assets/underscore-min.js"
  install_resource "${PODS_ROOT}/../../Assets/WPHybridCallbacker.js"
  install_resource "${PODS_ROOT}/../../Assets/WPHybridLogger.js"
  install_resource "${PODS_ROOT}/../../Assets/wpload.js"
  install_resource "${PODS_ROOT}/../../Assets/wpsave.js"
  install_resource "${PODS_ROOT}/../../Assets/ZSSRichTextEditor.js"
  install_resource "${PODS_ROOT}/../../Assets/wpposter.svg"
  install_resource "${PODS_ROOT}/../../Assets/editor.css"
  install_resource "${PODS_ROOT}/../../Assets/WPEditorFormatbarView.xib"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync --delete -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync --delete -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
