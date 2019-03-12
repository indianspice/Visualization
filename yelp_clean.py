
# coding: utf-8

# In[1]:


import pandas as pd


# In[28]:


#Read non hot new
bk_res = pd.read_csv('https://raw.githubusercontent.com/indianspice/Visualizations/master/Yelp/Bk1_restaurants.csv',
                    index_col = 0)
bk_res = pd.DataFrame(bk_res)

bk_groc = pd.read_csv('https://raw.githubusercontent.com/indianspice/Visualizations/master/Yelp/Bk1_grocery.csv',
                     index_col = 0)
bk_groc = pd.DataFrame(bk_groc)

bk_bars = pd.read_csv('https://raw.githubusercontent.com/indianspice/Visualizations/master/Yelp/Bk1_bars.csv',
                     index_col = 0)
bk_bars = pd.DataFrame(bk_bars)

bk_cafe = pd.read_csv('https://raw.githubusercontent.com/indianspice/Visualizations/master/Yelp/Bk1_cafes.csv',
                     index_col = 0)

bk_hot_new = pd.read_csv('https://raw.githubusercontent.com/indianspice/Visualizations/master/Yelp/Bk1_hot_new.csv', 
                         index_col = 0)
#bk_cafe = pd.DataFrame(bk_cafe)


# In[67]:


#concatinate all non-new dataframes
non_hot = bk_res.append([bk_res, bk_groc, bk_bars, bk_cafe], ignore_index=True, sort=False)

#drop columns
non_hot.drop(['alias', 'distance', 'id', 'image_url', 'url'], axis = 1, inplace = True)
non_hot.tail()

#non_hot.shape


# In[63]:


#drop columns
#bk_hot_new.drop(['alias', 'distance', 'id', 'image_url', 'url'], axis = 1, inplace = True)
bk_hot_new.shape


# In[60]:


#insert column with no
non_hot['hot_and_new']='no'
non_hot.shape


# In[68]:


#concat hot and not hot
bk_all = non_hot.append([bk_hot_new],ignore_index=True, sort=False)

bk_all.shape
#bk_all.head()


# In[70]:


bk_all.tail()

bk_all.to_csv('bk_all.csv')


# In[56]:


#unpack location dictionary
fin_loc =bk_all['location'].apply(pd.Series)
final = pd.concat([fin_cata1, fin_loc], axis = 1).drop('location', axis = 1)

