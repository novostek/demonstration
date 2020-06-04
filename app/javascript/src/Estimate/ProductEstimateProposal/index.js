import React, { useContext, useRef } from 'react'
import ProductEstimate from '../ProductEstimate'
import { EstimateContext } from '../../context/Estimate'
import Areas from '../Areas'

const ProductEstimateProposal = () => {
  const {
    productEstimate,
    estimate,
    handleSubmit,
    onSubmit,
    register,
    submitBtnRef,
    suggestions,
    addProduct,
    addSuggestionsToProductList,
  } = useContext(EstimateContext)

  return (
    <div>
      <form onSubmit={handleSubmit(onSubmit)} name="estimate_form">
        {
          productEstimate.map((pe, index) => (
            <div className="row products-area-list pl-1 pr-1 mt-2" id="measurement_proposals" key={index}>
              <div className="product-area">
                <Areas index={index} pe={pe} />
                <div className="products-list">
                  <input type="hidden" ref={register} name={`measurement_area[${index}]`} value={index} />
                  {
                    pe.products.map((product, peIndex) => (
                      <div className="product" key={peIndex}>
                        <div className="row pl-1 pr-1 products-search">
                          <ProductEstimate product={product} peIndex={peIndex} index={index} submitBtnRef={submitBtnRef} />
                        </div>
                      </div>
                    ))
                  }
                  <a onClick={() => addProduct(index)} style={{ height: '30px' }} className="product new-product">
                  </a>
                </div>
                <div className="products-suggestions mt-2">
                  {
                    (productEstimate[index].showSuggestions && Array.isArray(suggestions) && suggestions.length > 0)
                    &&
                    <h6 className="suggestions-title">Suggestions</h6>
                  }
                  {
                    // console.log(suggestions[index])
                    (productEstimate[index].showSuggestions && suggestions[index] && Array.isArray(suggestions[index].suggestions))
                    &&
                    suggestions[index].suggestions.map((suggestion, s_index) => {
                      return (
                        <a key={s_index} onClick={() => addSuggestionsToProductList(index, suggestion)} style={{ cursor: 'pointer' }}> {suggestion.name}</a>
                      )
                    })
                  }
                </div>

              </div>
            </div>
          ))
        }
        <button type="submit" style={{ display: 'none' }} ref={submitBtnRef}></button>
      </form>
    </div>
  )
}

export default ProductEstimateProposal
