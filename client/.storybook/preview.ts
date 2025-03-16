import type { Preview } from '@storybook/react'

document.dispatchEvent(new Event("DOMContentLoaded"));


const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
       color: /(background|color)$/i,
       date: /Date$/i,
      },
    },
  },
};

export default preview;