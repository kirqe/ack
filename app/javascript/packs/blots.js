import Quill from 'quill';
// import { EmbedPlaceholder, PlaceholderRegister } from 'quill-resize-module';

const FormatAttributesList = [
  'alt',
  'height',
  'width',
  'style',
  'class'
];

const BaseImageFormat = Quill.import('formats/image');

class ImageFormat extends BaseImageFormat {
  static formats(domNode) {
    return FormatAttributesList.reduce(function(formats, attribute) {
      if (domNode.hasAttribute(attribute)) {
        formats[attribute] = domNode.getAttribute(attribute);
      }
      return formats;
    }, {});
  }
  format(name, value) {
    if (FormatAttributesList.indexOf(name) > -1) {
      if (value) {
        this.domNode.setAttribute(name, value);
      } else {
        this.domNode.removeAttribute(name);
      }
    } else {
      super.format(name, value);
    }
  }
}

// VIDEO

const VideoFormat = Quill.import('blots/block/embed');

class Video extends VideoFormat {
  static formats(domNode) {
    return FormatAttributesList.reduce(function(formats, attribute) {
      if (domNode.hasAttribute(attribute)) {
        formats[attribute] = domNode.getAttribute(attribute);
      }
      return formats;
    }, {});
  }
  
  static create (value) {
    let node = super.create()
    node.setAttribute('src', value)
    node.setAttribute('controls', 'controls')
    node.setAttribute('width', "100%")
    node.setAttribute('height', "100%")
    node.setAttribute('webkit-playsinline', true)
    node.setAttribute('playsinline', true)
    node.setAttribute('x5-playsinline', true)
    node.setAttribute('preload', 'auto')
    
    return node;
  }
 
  static value (node) {
    return {
      url: node.getAttribute('src'),
    };
  }

}

Video.blotName = 'video'
Video.tagName = 'video'
Video.className = 'ql-video';

export { 
  ImageFormat,
  Video
}