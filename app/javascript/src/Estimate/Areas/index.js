import React, { useContext } from 'react'

import { EstimateContext } from "../../context/Estimate";
import { useTranslation } from 'react-i18next';

const Areas = ({index, pe}) => {
  const { 
    productEstimate, 
    setProductEstimate,
    register,
    estimate,
    refreshArea,
    selectArea,
    removeArea,
    handleTitleChange,
    toggleSelectAllAreas,
  } = useContext(EstimateContext)

  const { t } = useTranslation();

  return (
    <div>
      <a 
        onClick={() => removeArea(index, pe.proposal_id)} 
        style={{ cursor: 'pointer' }} 
        key={Math.random()} 
        className="btn-close-product-area">
          <i className="material-icons">close</i>
      </a>
      <div className="title">
        <label htmlFor="title">{t('estimate.areas.title')}</label>
        <input 
          type="text" 
          name={`measurement[${index}].title`} 
          ref={register}
          defaultValue={productEstimate[index].title}
          onChange={(e) => handleTitleChange(index, e.target.name, e.target.value)}/>
      </div>
      <div className="areas-available col">
        <span>{t('estimate.areas.items_for')}</span>
        {
          estimate.measurement_areas.map((ma, maIndex) => (
            <div 
              className={`chip ${productEstimate[index].areas.includes(ma.id) ? 'selected' : ''}`} 
              key={Math.random()} 
              onClick={() => !productEstimate[index].areas.includes(ma.id) ? selectArea(index, ma.id, true) : selectArea(index, ma.id, false)}>
              {ma.name}
            </div>
          ))
        }
        <div className="areas-available-actions">
          <a 
            onClick={() => toggleSelectAllAreas(index)} 
            style={{ cursor: 'pointer' }} 
            key={Math.random()} 
            className="select-all-areas">
              {productEstimate[index].toggleSelect ? 'Select all' : 'Deselect all'}
          </a>
          <a 
            onClick={() => refreshArea(index)} 
            style={{ cursor: 'pointer' }} 
            key={Math.random()} 
            className="btn-refresh-product-area">
              <i className="material-icons">refresh</i>
          </a>
        </div>
      </div>
    </div>
  )
}

export default Areas
