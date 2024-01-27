#!/bin/env python3
import tensorflow as tf
import numpy as np
from tensorflow.estimator import DNNClassifier

#https://www.tensorflow.org/tutorials/estimators/cnn#intro_to_convolutional_neural_networks

def training_data():
    data = {}
    data['feature'] = []
    data['label'] = []
    with tf.gfile.GFile('training_data.txt', 'r') as f:
        feature = True
        for line in f:
            if feature:
                data['feature'].append(np.asarray(list(map(float, line.split(' ')))))
            else:
                data['label'].append(np.argmax(list(map(float, line.split(' ')))))
            feature = not feature
    return tf.estimator.inputs.numpy_input_fn(
        x={'feature': np.asarray(data['feature'])},
        y=np.asarray(data['label']),
        num_epochs=None,
        batch_size=50,
        shuffle=True)

def test_data():
    data = {}
    data['feature'] = []
    data['label'] = []
    with tf.gfile.GFile('test_data.txt', 'r') as f:
        feature = True
        for line in f:
            if feature:
                data['feature'].append(np.asarray(list(map(float, line.split(' ')))))
            else:
                data['label'].append(int(line))
            feature = not feature
    return tf.estimator.inputs.numpy_input_fn(
        x={'feature': np.asarray(data['feature'])},
        y=np.asarray(data['label']),
        num_epochs=1,
        shuffle=False)

def cnn_model_fn(features, labels, mode):
    input_layer = tf.reshape(features['feature'], [-1, 28, 28, 1])

    conv1 = tf.layers.conv2d(
        inputs=input_layer,
        filters=32,
        kernel_size=[5, 5],
        padding='same',
        activation=tf.nn.relu)

    pool1 = tf.layers.max_pooling2d(inputs=conv1, pool_size=[2, 2], strides=2)

#    conv2 = tf.layers.conv2d(
#        inputs=pool1,
#        filters=64,
#        kernel_size=[5, 5],
#        padding='same',
#        activation=tf.nn.relu)
#    pool2 = tf.layers.max_pooling2d(inputs=conv2, pool_size=[2, 2], strides=2)

#    pool2_flat = tf.reshape(pool2, [-1, 7 * 7 * 64])
    pool2_flat = tf.reshape(pool1, [-1, 14 * 14 * 32])

    dense = tf.layers.dense(inputs=pool2_flat, units=1024, activation=tf.nn.relu)

    dropout = tf.layers.dropout(
        inputs=dense, rate=0.4, training=(mode == tf.estimator.ModeKeys.TRAIN))

    logits = tf.layers.dense(inputs=dropout, units=10)
    
    predictions = {
        'classes': tf.argmax(input=logits, axis=1),
        'probabilities': tf.nn.softmax(logits, name='softmax_tensor')
    }

    if mode == tf.estimator.ModeKeys.PREDICT:
        return tf.estimator.EstimatorSpec(mode=mode, predictions=predictions)

    loss = tf.losses.sparse_softmax_cross_entropy(labels=labels, logits=logits)

    if mode == tf.estimator.ModeKeys.TRAIN:
        optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.001)
        train_op = optimizer.minimize(
            loss=loss,
            global_step=tf.train.get_global_step())
        return tf.estimator.EstimatorSpec(mode=mode, loss=loss, train_op=train_op)

    eval_metric_ops = {
        'accuracy': tf.metrics.accuracy(
            labels=labels, predictions=predictions['classes'])}
    return tf.estimator.EstimatorSpec(
        mode=mode, loss=loss, eval_metric_ops=eval_metric_ops)

tf.logging.set_verbosity(tf.logging.INFO)

estimator = tf.estimator.Estimator(model_fn=cnn_model_fn)
estimator.train(input_fn=training_data(), steps=5000)
print(estimator.evaluate(test_data()))

