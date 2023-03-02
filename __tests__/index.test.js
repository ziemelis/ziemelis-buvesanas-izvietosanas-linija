import { render } from '@testing-library/react'
import Home from '../pages/index.js'

describe('Home', () => {
  it('renders without errors', () => {
    render(<Home />)
  })
})
