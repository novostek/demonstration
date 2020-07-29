import React, { useEffect, useState, useContext } from 'react'
import moment from 'moment'
import { useForm } from "react-hook-form";
import axios from 'axios';
import * as yup from "yup";
import { EstimateContext } from '../../context/Estimate';
import { useTranslation } from 'react-i18next';

const schema = yup.object().shape({
  tax_calculation: yup.string().required(),
  ataxpayerge: yup.string().required(),
});

const EstimateDetail = () => {
  const { productEstimate, setProductEstimate, estimate } = useContext(EstimateContext)
  const { register, handleSubmit, setValue } = useForm()
  const { t } = useTranslation()

  const onChangeTax = async formData => {
    const data = await axios.put(`/estimates/${estimate.id}/tax_calculation`, { tax_calculation: formData.tax_calculation })
  }

  const onChangeTaxPayer = async formData => {
    const data = await axios.put(`/estimates/${estimate.id}/taxpayer`, { taxpayer: formData.taxpayer })
  }

  const [taxes, setTaxes] = useState([{}])

  useEffect(() => {
    const initialLoad = async () => {
      const {data} = await axios.get('/calculation_formulas/taxes')
      setTaxes(data)
    }

    initialLoad()
  }, [])

  useEffect(() => {
    
    setValue('tax_calculation', estimate.tax_calculation_id)
    setValue('taxpayer', estimate.taxpayer)
    M.AutoInit()
  }, [taxes,])

  return (
    <div className="section">
      <div className="card-panel estimate-details">
        <div className="row">
          <div className="col s5">
            <h6>{estimate.title}</h6>
            <span>{estimate.description}</span>
          </div>
          <div className="col s5">
            <span style={{width: '100%'}} className="left">{t("estimate.detail.labels.customer")}: {estimate.lead.customer.name}</span>
            <span style={{width: '100%'}} className="left">{t("estimate.detail.labels.location")}: {estimate.location}</span>
            <span style={{width: '100%'}} className="left">{estimate.category}</span>
          </div>
          <div className="col s2">
            <span className="chip lighten-5 green green-text right mr-0">{estimate.status}</span>
            <span style={{width: '100%'}} className="right right-align">{moment(estimate.created_at).format("MM/DD/YYYY")}</span>
          </div>
        </div>
        
        {
          !window.location.pathname.includes('orders')
          &&
          <div className="row mt-3">
            <div className="col s12">
              <form name="tax_form">
                <div className="row">
                  <div className="input-field col s12 m3 l4">
                    {
                      taxes.length > 0
                      &&
                      <div>
                        <select name="tax_calculation" required ref={register} onChange={handleSubmit(onChangeTax)}>
                          <option value="">{t("estimate.detail.tax_select")}</option>
                          {
                            taxes.map(tax => (
                              <option key={tax.id} value={tax.id}>{tax.name}</option>
                            ))
                          }
                        </select>
                        <label>{t("estimate.detail.labels.tax")}</label>
                      </div>
                    }
                  </div>

                  <div className="input-field col s12 m3 l3">
                    <select name="taxpayer" required onChange={handleSubmit(onChangeTaxPayer)} ref={register}>
                      <option value="">{t("estimate.detail.select.select_option")}</option>
                      <option value="customer">{t("estimate.detail.select.customer_pay")}</option>
                      <option value="company">{t("estimate.detail.select.we_pay")}</option>
                    </select>
                    <label>{t("estimate.detail.labels.taxpayer")}</label>
                      {/* <%= f.select :taxpayer, Estimate.taxpayer.options, {prompt: true}, :selected => @estimate.taxpayer, required: true  %>
                      <%= f.label  :taxpayer %> */}
                  </div>  
                </div>    
              </form>
            </div>
          </div>
        }        
      </div>
    </div>
  )
}

export default EstimateDetail
