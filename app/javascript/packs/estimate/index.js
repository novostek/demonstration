import React from 'react'
import ReactDOM from 'react-dom'
import ProductComponent from "../../src/Estimate"
import EstimateProvider from '../../src/context/Estimate'


document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <EstimateProvider>
      <ProductComponent />
    </EstimateProvider>,
    document.getElementById('react-component'),
  )
})